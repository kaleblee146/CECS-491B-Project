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
    
    # CSS for styling
    html.Style('''
        body {
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
            background-color: #121212;
            color: white;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }
        
        .app-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 16px 24px;
            border-bottom: 1px solid #333;
        }
        
        .header-quote {
            font-size: 18px;
            font-weight: bold;
            margin: 0;
        }
        
        .profile-picture {
            width: 48px;
            height: 48px;
            background-color: #e91e63;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .profile-icon {
            font-size: 24px;
        }
        
        .progress-container {
            background-color: #222;
            border-radius: 8px;
            margin: 16px;
            padding: 24px;
        }
        
        .section-title {
            font-size: 24px;
            font-weight: bold;
            margin-bottom: 24px;
        }
        
        .day-buttons-container {
            display: flex;
            justify-content: space-around;
            margin-bottom: 8px;
        }
        
        .day-button {
            width: 48px;
            height: 48px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            font-weight: bold;
            background-color: #333;
            color: #ccc;
            border: none;
            cursor: pointer;
        }
        
        .day-active {
            background-color: #e91e63;
            color: white;
        }
        
        .date-range-container {
            display: flex;
            justify-content: space-between;
            font-size: 12px;
            color: #999;
            padding: 0 8px;
        }
        
        .workouts-container {
            flex: 1;
            padding: 0 16px 16px;
            overflow-y: auto;
        }
        
        .workout-card {
            background-color: #222;
            border-radius: 8px;
            margin-bottom: 12px;
            overflow: hidden;
        }
        
        .workout-header {
            padding: 16px;
            display: flex;
            align-items: center;
            cursor: pointer;
        }
        
        .workout-status {
            width: 24px;
            height: 24px;
            border-radius: 50%;
            background-color: #444;
            margin-right: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .completed {
            background-color: #4caf50;
        }
        
        .workout-title {
            flex: 1;
            margin: 0;
            font-size: 16px;
            font-weight: 500;
        }
        
        .expand-button {
            background: none;
            border: none;
            color: white;
            font-size: 18px;
            cursor: pointer;
        }
        
        .workout-details {
            background-color: #333;
            padding: 12px 16px;
        }
        
        .exercise-title {
            font-size: 14px;
            font-weight: 500;
            color: #ccc;
            margin-bottom: 8px;
        }
        
        .exercise-list {
            padding-left: 16px;
            margin-bottom: 12px;
        }
        
        .exercise-list li {
            margin-bottom: 8px;
            font-size: 14px;
        }
        
        .workout-action-button {
            width: 100%;
            background-color: #e91e63;
            color: white;
            border: none;
            border-radius: 8px;
            padding: 8px 16px;
            font-size: 14px;
            cursor: pointer;
            margin-top: 12px;
        }
        
        .bottom-nav {
            display: grid;
            grid-template-columns: repeat(5, 1fr);
            gap: 8px;
            background-color: #222;
            padding: 16px;
            border-top: 1px solid #333;
        }
        
        .nav-button {
            display: flex;
            flex-direction: column;
            align-items: center;
            background: none;
            border: none;
            color: #999;
            cursor: pointer;
        }
        
        .nav-button.active {
            color: #e91e63;
        }
        
        .nav-icon {
            font-size: 20px;
            margin-bottom: 4px;
        }
        
        .nav-label {
            font-size: 12px;
        }
    ''')
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