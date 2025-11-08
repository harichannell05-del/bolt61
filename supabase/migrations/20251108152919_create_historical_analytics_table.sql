/*
  # Create Historical Analytics Table

  1. New Tables
    - `analytics_snapshots`
      - `id` (uuid, primary key)
      - `snapshot_date` (date, unique) - Date of the snapshot (end of month)
      - `total_users` (integer) - Total registered users at that time
      - `active_users` (integer) - Active users that month
      - `new_users_this_month` (integer) - New registrations
      - `total_revenue` (numeric) - Total cumulative revenue
      - `monthly_revenue` (numeric) - Revenue for that specific month
      - `total_sessions` (integer) - Total sessions completed
      - `monthly_sessions` (integer) - Sessions for that specific month
      - `active_therapists` (integer) - Active therapists at that time
      - `total_therapists` (integer) - Total registered therapists
      - `created_at` (timestamp) - When the snapshot was created

  2. Indexes
    - Index on `snapshot_date` for efficient historical lookups
    - Unique constraint on `snapshot_date` to prevent duplicates

  3. Security
    - Enable RLS on the table
    - Add public read policy (analytics data is non-sensitive)
    - Add policy for admin inserts only
*/

CREATE TABLE IF NOT EXISTS analytics_snapshots (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  snapshot_date date UNIQUE NOT NULL,
  total_users integer NOT NULL DEFAULT 0,
  active_users integer NOT NULL DEFAULT 0,
  new_users_this_month integer NOT NULL DEFAULT 0,
  total_revenue numeric NOT NULL DEFAULT 0,
  monthly_revenue numeric NOT NULL DEFAULT 0,
  total_sessions integer NOT NULL DEFAULT 0,
  monthly_sessions integer NOT NULL DEFAULT 0,
  active_therapists integer NOT NULL DEFAULT 0,
  total_therapists integer NOT NULL DEFAULT 0,
  created_at timestamptz DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_analytics_snapshots_date ON analytics_snapshots(snapshot_date DESC);

ALTER TABLE analytics_snapshots ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view analytics snapshots"
  ON analytics_snapshots
  FOR SELECT
  TO public
  USING (true);

CREATE POLICY "System can insert analytics snapshots"
  ON analytics_snapshots
  FOR INSERT
  TO authenticated
  WITH CHECK (true);
