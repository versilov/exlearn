#ifndef INCLUDED_ACTIVITY_H
#define INCLUDED_ACTIVITY_H

void              free_activity(Activity *);
Activity *        new_activity(int);
void              call_activity_closure(ActivityClosure *, Matrix);
void              free_activity_closure(ActivityClosure *);
ActivityClosure * new_activity_closure(ActivityFunction, float);
ActivityClosure * activity_determine_function(int, float);
ActivityClosure * activity_determine_derivative(int, float);

#endif
