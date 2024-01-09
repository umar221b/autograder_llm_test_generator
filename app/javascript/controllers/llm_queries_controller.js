import { Controller } from "@hotwired/stimulus"
import axios from "lib/axios";

const SUBMIT_ENDPOINT = '/llm_queries';

function setInputs(target, enable) {
    target.problem_statement.disabled = enable;
    target.reference_solution.disabled = enable;
    target.query_type.disabled = enable;
}

export default class extends Controller {
    submit(event) {
        event.preventDefault();
        const responseDiv = document.getElementById("response-div");
        if (! responseDiv.classList.contains('d-none') && !confirm('Are you sure? This will remove your previous request.'))
            return

        responseDiv.classList.add("d-none");

        event.target.submitButton.disabled = true;
        event.target.submitButton.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Loading...'
        setInputs(event.target, true);

        let params = {
            problem_statement: event.target.problem_statement.value,
            reference_solution: event.target.reference_solution.value,
            query_type: event.target.query_type.value
        }

        axios.post(SUBMIT_ENDPOINT, { llm_query: params }).then((resp) => {
            const responseDiv = document.getElementById("response-div");

            const responseBadge = document.getElementById("response-badge");
            responseBadge.innerHTML = resp.data.data.tokens.join(' + ');

            const responseTextarea = document.getElementById("response-area");
            responseTextarea.innerHTML = resp.data.data.message;

            if (event.target.query_type.value === 'unit_tests') {
                const responseCodeTextarea = document.getElementById("response-code-area");
                responseCodeTextarea.innerHTML = resp.data.data.code;
            }

            responseDiv.classList.remove("d-none");
            event.target.submitButton.innerHTML = 'Generate'
            event.target.submitButton.disabled = false;
            setInputs(event.target, false);
        }).catch((error) => {
            console.log(error)
            alert(error.response.data['error']);
            event.target.submitButton.innerHTML = 'Generate'
            event.target.submitButton.disabled = false;
            setInputs(event.target, false);
        });
    }
    switchOutputType(event) {
        const responseDiv = document.getElementById("response-div");
        if (event.target.value === 'matching_outputs')
            responseDiv.innerHTML = '<div class="col-12"> <h3>Response</h3> </div> <div class="col-12"> <h4 class="mt-4">Inputs <span id="response-badge" class="badge bg-success"></span></h4> <textarea disabled id="response-area" class="form-control" rows="16"></textarea> </div>'
        else if (event.target.value === 'unit_tests')
            responseDiv.innerHTML = '<div class="col-12"> <h3>Response</h3> </div> <div class="col-12 col-md-6"> <h4 class="mt-4">Full Response <span id="response-badge" class="badge bg-success"></span></h4> <textarea disabled id="response-area" class="form-control" rows="16"></textarea> </div> <div class="col-12 col-md-6"> <h4 class="mt-4">Extracted Code</h4> <textarea disabled id="response-code-area" class="form-control" rows="16"></textarea> </div>'
    }
}
