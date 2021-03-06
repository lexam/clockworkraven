# Copyright 2012 Twitter, Inc. and others.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Approves tasks on MTurk
class ApproveProcessor < Job::ThreadPoolProcessor
  NAME = "Approving Tasks"
  KILL_MESSAGE = <<-END
    Some tasks may have been approved. To finish approving tasks, use the
    "Approve All Unapproved Responses" button again.
  END

  def process task_id
    MTurkUtils.approve Task.find(task_id)
  end

  def after
    e = Evaluation.find(options['evaluation_id'])
    e.status = Evaluation::STATUS_ID[:approved]
    e.save!
  end
end