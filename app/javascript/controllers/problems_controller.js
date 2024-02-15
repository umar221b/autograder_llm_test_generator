import { Controller } from "@hotwired/stimulus"
import axios from "lib/axios";

const SUBMIT_ENDPOINT = '/problems';

function setInputs(target, enable) {
    target.problem_title.disabled = enable;
    target.problem_statement.disabled = enable;
    target.reference_solution.disabled = enable;
    target.extra_code.disabled = enable;
    target.programming_language.disabled = enable;
    target.test_type.disabled = enable;
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
            title: event.target.problem_title.value,
            statement: event.target.problem_statement.value,
            reference_solution: event.target.reference_solution.value,
            extra_code: event.target.extra_code.value,
            programming_language: event.target.programming_language.value,
            test_type: event.target.test_type.value
        }

        axios.post(SUBMIT_ENDPOINT, { problem: params }).then((resp) => {
            const responseDiv = document.getElementById("response-div");

            let llm_chat_query = resp.data.data.llm_chat_query;

            const responseTextarea = document.getElementById("response-area");
            responseTextarea.innerHTML = llm_chat_query.response;

            // if (event.target.test_type.value === 'unit_tests') {
            //     const responseCodeTextarea = document.getElementById("response-code-area");
            //     responseCodeTextarea.innerHTML = resp.data.data.code;
            // }

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
        return // TODO: Remove after fixing responses returned from backend

        const responseDiv = document.getElementById("response-div");
        const programmingLanguageSelect = document.getElementById("programming_language");

        if (event.target.value === 'matching_outputs') {
            responseDiv.innerHTML = '<div class="col-12"> <h3>Response</h3> </div> <div class="col-12"> <h4 class="mt-4">Inputs</h4> <textarea disabled id="response-area" class="form-control" rows="16"></textarea> </div>'
            programmingLanguageSelect.innerHTML = '<option value="c">C</option><option selected="selected" value="python3">Python 3</option>'
        }
        else if (event.target.value === 'unit_tests') {
            responseDiv.innerHTML = '<div class="col-12"> <h3>Response</h3> </div> <div class="col-12 col-md-6"> <h4 class="mt-4">Full Response</h4> <textarea disabled id="response-area" class="form-control" rows="16"></textarea> </div> <div class="col-12 col-md-6"> <h4 class="mt-4">Extracted Code</h4> <textarea disabled id="response-code-area" class="form-control" rows="16"></textarea> </div>'
            programmingLanguageSelect.innerHTML = '<option selected="selected" value="python3">Python 3</option>'
        }
    }
}
