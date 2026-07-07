{ config, options, lib, pkgs, ... }:
{
  programs.taskwarrior = {
    enable = true;
    dataLocation = "~/.task";
    colorTheme = "dark-violets-256";

    extraConfig = ''
      # --- UDA Definitions ---
      uda.state.label=State
      uda.state.type=string
      uda.state.values=maybe,await,pending,nextaction,doing,proj
      uda.state.default=pending
      uda.state.description="Category list the task is in."

      uda.outcome.label=Outcome
      uda.outcome.type=string

      uda.why.label=Why
      uda.why.type=string

      uda.context.label=Context
      uda.context.type=string
      uda.context.values=home,computer,outdoor,lab,internet,anywhere,ereader,errand,agenda,mail,papier,phone,none
      uda.context.default=none

      uda.energy.label=Energy
      uda.energy.type=string
      uda.energy.values=mental,creative,physical,little,mundane
      uda.energy.default=mental

      uda.priority.label=Priority
      uda.priority.type=string
      uda.priority.values=?,l,m,h,c
      uda.priority.default=?

      uda.value.label=Value
      uda.value.type=string
      uda.value.values=?,0,1,2,3,5,8
      uda.value.default=?

      uda.note.label=Note
      uda.note.type=string
      uda.note.values=n,y
      uda.note.default=n

      uda.effort.label=Effort
      uda.effort.type=string
      uda.effort.values=13,8,5,?,3,2,1,0
      uda.effort.default=?

      uda.time.label=Time
      uda.time.type=string
      uda.time.values=13,8,5,?,3,2,1,0
      uda.time.default=?

      uda.review.label=Review due
      uda.review.type=string

      # --- Refined Urgency Coefficients ---
      urgency.uda.priority.?.coefficient=0
      urgency.uda.priority.l.coefficient=2
      urgency.uda.priority.m.coefficient=5
      urgency.uda.priority.h.coefficient=10
      urgency.uda.priority.c.coefficient=15

      urgency.uda.value.?.coefficient=0
      urgency.uda.value.0.coefficient=0
      urgency.uda.value.1.coefficient=2
      urgency.uda.value.2.coefficient=4
      urgency.uda.value.3.coefficient=6
      urgency.uda.value.5.coefficient=9
      urgency.uda.value.8.coefficient=12

      urgency.uda.effort.?.coefficient=0
      urgency.uda.effort.0.coefficient=3
      urgency.uda.effort.1.coefficient=2
      urgency.uda.effort.2.coefficient=1
      urgency.uda.effort.3.coefficient=0
      urgency.uda.effort.5.coefficient=-2
      urgency.uda.effort.8.coefficient=-4
      urgency.uda.effort.13.coefficient=-6

      urgency.user.tag.important.coefficient=5
      urgency.user.tag.critical.coefficient=8
      urgency.user.tag.urgent.coefficient=5
      urgency.user.tag.1m.coefficient=3
      urgency.user.tag.2m.coefficient=2
      urgency.user.tag.5m.coefficient=1
      urgency.user.tag.10m.coefficient=1
      urgency.user.tag.life.coefficient=5
      urgency.user.tag.lifegoal.coefficient=5

        # --- Reports ---
      report.mailr.labels=Project,Description,Dependency,Tags,Due,Sched,Start,Until,End,Entry
      report.mailr.columns=project,description,depends,tags,due.remaining,scheduled.countdown,start.age,until.remaining,end.remaining,entry.age
      report.mailr.filter=status:pending -WAITING
      report.mailr.sort=urgency-,due+
      report.mailr.context=0

      report.next.columns=id,project,tags,context,state,description.count,outcome,urgency
      report.next.labels=ID,Project,Tags,Context,State,Description,Outcome,U
      report.next.filter=status:pending -WAITING ((state:'nextaction' and project:'''') or state:'proj' or state:'await') limit:page -BLOCKED

      report.decide.columns=id,priority,value,effort,description,tags,context,state,outcome,project
      report.decide.labels=ID,Priority,Value,Effort,Desc,Tags,Context,State,Outcome,Project
      report.decide.filter=(status:pending -WAITING) and state.not:'proj' and state.not:'maybe' -project limit:page
      report.decide.sort=urgency-

      report.maybe.columns=id,priority,project,context,description.count,outcome
      report.maybe.labels=ID,P,Project,Context,Description,Outcome
      report.maybe.filter=state:maybe
      report.maybe.sort=urgency-

      report.inbox.columns=id,priority,project,context,description.count,outcome
      report.inbox.labels=ID,P,Project,Context,Description,Outcome
      report.inbox.filter=(state:pending and status:pending) -WAITING
      report.inbox.sort=entry-
      report.inbox.context=0

      report.top.labels=ID
      report.top.columns=id
      report.top.filter=status:pending -WAITING
      report.top.sort=urgency-

      report.l.columns=id,start.active,depends,project,tags,state,recur.indicator,wait.remaining,scheduled.remaining,due.remaining,until.remaining,description.count,note
      report.l.description=Show short details about tasks
      report.l.filter=(status:pending or +WAITING) and limit:page
      report.l.labels=ID,A,D,Project,T,State,R,Wait,S,Due,Until,Description,Note
      report.l.sort=urgency-,due+

      report.t.columns=id,start.active,depends,state,recur.indicator,wait.remaining,scheduled.remaining,due.remaining,until.remaining,description,note
      report.t.description=Show short details about tasks
      report.t.filter=(status:pending or +WAITING) and limit:page
      report.t.labels=ID,A,D,State,R,Wait,S,Due,Until,Description,Note
      report.t.sort=urgency-,due+

      report.project.columns=id,start.active,depends,tags,description.count,state,recur.indicator,wait.remaining,scheduled.remaining,due.remaining,until.remaining,note
      report.project.description=Show short details about projects main task
      report.project.filter=(state:proj or +project) and limit:none and project.not:""
      report.project.labels=ID,A,Deps,T,Desc,State,R,Wait,S,Due,Until,Note
      report.project.sort=urgency-,due+

      report.review.columns=id,project,tags,state,description
      report.review.labels=ID,Project,Tags,State,Description
      report.review.filter=state:maybe or state:proj
      report.review.sort=project+,urgency-
      report.review.description=Review projects and 'maybe' items.

      report.focus.columns=id,project,description
      report.focus.labels=ID,Project,Description
      report.focus.filter=status:pending -WAITING state:nextaction
      report.focus.sort=urgency-
      report.focus.description=The immediate focus for today.

      # --- Contexts ---
      context.admin.read=+admin
      context.admin.write=+admin
      context.brain.read=state:nextaction and +brain
      context.brain.write=state:nextaction +brain
      context.easy.read=state:nextaction and ( +easy or +quick or +fast or +1m or +2m or +5m )
      context.easy.write=state:nextaction +easy
      context.intray.read=state:pending
      context.intray.write=state:pending
      context.maybe.read=+maybe or +someday or state:maybe
      context.maybe.write=state:maybe
      context.pending.read=state:pending
      context.pending.write=state:pending
      context.projects.read=state:proj
      context.projects.write=state:proj
      context.wait.read=state:await or +WAITING
      context.wait.write=state:await +WAITING

      news.version=2.6.0
    '';
  };
}
