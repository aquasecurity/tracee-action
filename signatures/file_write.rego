package tracee.TRC_1001
import data.tracee.helpers

__rego_metadoc__ := {
	"id": "TRC_1001",
	"version": "0.1.0",
	"name": "file_write",
	"eventName": "file_write",
	"description": "A file is being written to",
}

tracee_selected_events[eventSelector] {
	eventSelector := {
		"source": "tracee",
		"name": "security_file_open",
	}
}

tracee_match = res {
	input.eventName == "security_file_open"
	helpers.is_file_write(helpers.get_tracee_argument("flags"))
	pathname := helpers.get_tracee_argument("pathname")
  res := {
    "pathname": pathname,
  }
}
