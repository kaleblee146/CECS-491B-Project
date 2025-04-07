import dash
from dash import dcc, html, Input, Output, State, callback
import dash_bootstrap_components as dbc
from django_plotly_dash import DjangoDash

# Initialize the Dash app using DjangoDash instead of dash.Dash
app = DjangoDash('dash_app', external_stylesheets=[dbc.themes.DARKLY])

# Define the app layout
app.layout = html.Div([
    # Header with motivational quote
    html.Header([
        html.H1('"Each day! of training makes you a little stronger"', 
                className='header-quote'),
        html.Div(html.Span('👤', className='profile-icon'), 
                className='profile-picture')
    ], className='app-header'),
    
    # Progress section
    html.Div([
        html.H2("Let's look at your Progress!", className='section-title'),
        
        # Day selection buttons
        html.Div([
            html.Button('4', id='day-4', className='day-button'),
            html.Button('5', id='day-5', className='day-button'),
            html.Button('6', id='day-6', className='day-button'),
            html.Button('7', id='day-7', className='day-button day-active'),
            html.Button('8', id='day-8', className='day-button'),
            html.Button('9', id='day-9', className='day-button'),
        ], className='day-buttons-container'),
        
        # Date range labels
        html.Div([
            html.Span('April 4', className='date-range-label'),
            html.Span('April 9', className='date-range-label'),
        ], className='date-range-container'),
    ], className='progress-container'),
    
    # Workout list
    html.Div([
        # Chest Workout
        html.Div([
            html.Div([
                html.Div('✓', className='workout-status completed'),
                html.H3('Chest Workout', className='workout-title'),
                html.Button('▶', id='expand-chest', className='expand-button'),
            ], className='workout-header'),
            # Hidden by default
            html.Div([
                html.H4('Exercises:', className='exercise-title'),
                html.Ul([
                    html.Li('Bench Press'),
                    html.Li('Incline Press'),
                    html.Li('Chest Flys'),
                    html.Li('Push-ups'),
                ], className='exercise-list'),
                html.Button('View Details', className='workout-action-button'),
            ], id='chest-details', className='workout-details', style={'display': 'none'}),
        ], className='workout-card'),
        
        # Quads & Deltoids Workout
        html.Div([
            html.Div([
                html.Div('', className='workout-status'),
                html.H3('Quads & Deltoids Workout', className='workout-title'),
                html.Button('▶', id='expand-quads', className='expand-button'),
            ], className='workout-header'),
            # Hidden by default
            html.Div([
                html.H4('Exercises:', className='exercise-title'),
                html.Ul([
                    html.Li('Squats'),
                    html.Li('Leg Press'),
                    html.Li('Shoulder Press'),
                    html.Li('Lateral Raises'),
                ], className='exercise-list'),
                html.Button('Start Workout', className='workout-action-button'),
            ], id='quads-details', className='workout-details', style={'display': 'none'}),
        ], className='workout-card'),
        
        # Push up Routine
        html.Div([
            html.Div([
                html.Div('✓', className='workout-status completed'),
                html.H3('Push up Routine', className='workout-title'),
                html.Button('▶', id='expand-pushup', className='expand-button'),
            ], className='workout-header'),
            # Hidden by default
            html.Div([
                html.H4('Exercises:', className='exercise-title'),
                html.Ul([
                    html.Li('Standard Push-ups'),
                    html.Li('Diamond Push-ups'),
                    html.Li('Wide Push-ups'),
                    html.Li('Decline Push-ups'),
                ], className='exercise-list'),
                html.Button('View Details', className='workout-action-button'),
            ], id='pushup-details', className='workout-details', style={'display': 'none'}),
        ], className='workout-card'),
        
        # Legs Workout
        html.Div([
            html.Div([
                html.Div('', className='workout-status'),
                html.H3('Legs Workout', className='workout-title'),
                html.Button('▶', id='expand-legs', className='expand-button'),
            ], className='workout-header'),
            # Hidden by default
            html.Div([
                html.H4('Exercises:', className='exercise-title'),
                html.Ul([
                    html.Li('Squats'),
                    html.Li('Lunges'),
                    html.Li('Deadlifts'),
                    html.Li('Calf Raises'),
                ], className='exercise-list'),
                html.Button('Start Workout', className='workout-action-button'),
            ], id='legs-details', className='workout-details', style={'display': 'none'}),
        ], className='workout-card'),
        
    ], className='workouts-container'),
    
    # Bottom navigation
    html.Div([
        html.Button([
            html.Span('🏠', className='nav-icon'),
            html.Span('Home', className='nav-label active')
        ], className='nav-button active'),
        html.Button([
            html.Span('📊', className='nav-icon'),
            html.Span('Stats', className='nav-label')
        ], className='nav-button'),
        html.Button([
            html.Span('👤', className='nav-icon'),
            html.Span('Profile', className='nav-label')
        ], className='nav-button'),
        html.Button([
            html.Span('🔍', className='nav-icon'),
            html.Span('Search', className='nav-label')
        ], className='nav-button'),
        html.Button([
            html.Span('⚙️', className='nav-icon'),
            html.Span('Settings', className='nav-label')
        ], className='nav-button'),
    ], className='bottom-nav'),
])

# Callbacks for workout expansion
@app.callback(
    Output('chest-details', 'style'),
    Input('expand-chest', 'n_clicks'),
    State('chest-details', 'style'),
    prevent_initial_call=True
)
def toggle_chest_details(n_clicks, style):
    if style.get('display') == 'none':
        return {'display': 'block'}
    else:
        return {'display': 'none'}

@app.callback(
    Output('quads-details', 'style'),
    Input('expand-quads', 'n_clicks'),
    State('quads-details', 'style'),
    prevent_initial_call=True
)
def toggle_quads_details(n_clicks, style):
    if style.get('display') == 'none':
        return {'display': 'block'}
    else:
        return {'display': 'none'}

@app.callback(
    Output('pushup-details', 'style'),
    Input('expand-pushup', 'n_clicks'),
    State('pushup-details', 'style'),
    prevent_initial_call=True
)
def toggle_pushup_details(n_clicks, style):
    if style.get('display') == 'none':
        return {'display': 'block'}
    else:
        return {'display': 'none'}

@app.callback(
    Output('legs-details', 'style'),
    Input('expand-legs', 'n_clicks'),
    State('legs-details', 'style'),
    prevent_initial_call=True
)
def toggle_legs_details(n_clicks, style):
    if style.get('display') == 'none':
        return {'display': 'block'}
    else:
        return {'display': 'none'}

# Callbacks for day selection
@app.callback(
    [Output('day-4', 'className'),
     Output('day-5', 'className'),
     Output('day-6', 'className'),
     Output('day-7', 'className'),
     Output('day-8', 'className'),
     Output('day-9', 'className')],
    [Input('day-4', 'n_clicks'),
     Input('day-5', 'n_clicks'),
     Input('day-6', 'n_clicks'),
     Input('day-7', 'n_clicks'),
     Input('day-8', 'n_clicks'),
     Input('day-9', 'n_clicks')],
    prevent_initial_call=True
)
def update_active_day(n1, n2, n3, n4, n5, n6):
    ctx = dash.callback_context
    if not ctx.triggered:
        # Default active day is 7
        return ['day-button', 'day-button', 'day-button', 
                'day-button day-active', 'day-button', 'day-button']
    
    button_id = ctx.triggered[0]['prop_id'].split('.')[0]
    
    # Set the active class for the clicked button
    day_classes = ['day-button', 'day-button', 'day-button', 
                   'day-button', 'day-button', 'day-button']
    
    if button_id == 'day-4':
        day_classes[0] = 'day-button day-active'
    elif button_id == 'day-5':
        day_classes[1] = 'day-button day-active'
    elif button_id == 'day-6':
        day_classes[2] = 'day-button day-active'
    elif button_id == 'day-7':
        day_classes[3] = 'day-button day-active'
    elif button_id == 'day-8':
        day_classes[4] = 'day-button day-active'
    elif button_id == 'day-9':
        day_classes[5] = 'day-button day-active'
    
    return day_classes

# If we were to integrate with Django models, we could add data loading callbacks here
# For example, to load workout data from the database when a date is selected
# @app.callback(
#     [Output('workout-data-container', 'children')],
#     [Input('day-4', 'n_clicks'), Input('day-5', 'n_clicks'), ...]
# )
# def load_workout_data(n1, n2, ...):
#     ctx = dash.callback_context
#     if not ctx.triggered:
#         return [html.Div()]
#     
#     button_id = ctx.triggered[0]['prop_id'].split('.')[0]
#     day = button_id.split('-')[1]
#     
#     # Here you would use Django ORM to load data
#     # from django.shortcuts import get_object_or_404
#     # from .models import Workout
#     # workouts = Workout.objects.filter(day=day)
#     
#     # Then return components built with the data
#     # return [html.Div([...] for workout in workouts)]
