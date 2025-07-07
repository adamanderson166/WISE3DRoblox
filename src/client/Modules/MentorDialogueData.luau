local Data = table.freeze({
	["Matthew McConaughey"] = {
		{
			Topic = "Life Philosophy",
			Dialogue = "Life isn't about chasing perfection. Each day, show up honestly and give your best, even when you don't feel 100%. That's how character is built.",
		},
		{
			Topic = "Routine Building",
			Dialogue = "A solid morning routine—movement, mindfulness, and motivation—sets your compass for the day. Build yours brick by brick, starting small.",
		},
		{
			Topic = "Confidence",
			Dialogue = "Confidence is earned by preparation. Speak up, even if your voice shakes. Over time, your courage turns to calm.",
		},
		{
			Topic = "Perseverance",
			Dialogue = "When you feel stuck, remember: a little progress every day adds up. Keep stepping forward, no matter the size of the step.",
		},

		{
			Topic = "Legacy",
			Dialogue = "Think about how you want to be remembered—not just for your accomplishments, but how you made others feel. That’s your legacy.",
		},
	},

	["Camila Alves"] = {
		{
			Topic = "Healthy Eating",
			Dialogue = "Healthy meals start with colorful choices. Aim to fill half your plate with fruits and vegetables—it’s simple, but powerful.",
		},

		{
			Topic = "Kitchen Safety",
			Dialogue = "Safety in the kitchen is the first ingredient of a good dish. Wash your hands, use sharp tools wisely, and stay focused.",
		},
		{
			Topic = "Balanced Diet",
			Dialogue = "A balanced diet means a bit of everything: proteins for strength, carbs for energy, and fats for function. Moderation is key.",
		},
		{
			Topic = "Cooking Tips",
			Dialogue = "Cooking tip of the day: always taste as you go. Adjusting flavors while cooking makes a big difference in the final dish.",
		},
		{
			Topic = "Food Origins",
			Dialogue = "Where your food comes from matters. Understanding local and seasonal ingredients helps you cook better—and live better too.",
		},
	},

	["Computer Engineer"] = {
		{
			Topic = "Programming Fundamentals",
			Dialogue = "Programming starts with logic. Think like a computer—break big tasks into smaller, step-by-step instructions and troubleshoot patiently.",
		},

		{
			Topic = "Problem Solving",
			Dialogue = "Good coders are great problem solvers. Debugging isn't failure—it's discovery. Use each bug as a learning checkpoint.",
		},
		{
			Topic = "Cybersecurity",
			Dialogue = "Your data is valuable—so protect it. Always use strong passwords and enable two-factor authentication where you can.",
		},
		{
			Topic = "Data Structures",
			Dialogue = "Data structures are how we organize info. Think of arrays like rows of lockers and linked lists like a treasure hunt.",
		},
		{
			Topic = "AI & Ethics",
			Dialogue = "AI can do amazing things, but it must be used responsibly. Bias in algorithms is real—diverse teams help create fair systems.",
		},
	},
	["Artist Mentor"] = {
		{
			Topic = "Color Theory",
			Dialogue = "Understanding warm and cool colors helps set mood in your work. Red excites, blue calms—use with purpose.",
		},
		{
			Topic = "Sketching Basics",
			Dialogue = "Sketching isn't about perfection—it's about seeing. Practice drawing basic shapes every day. Your hand will improve faster than you think.",
		},
		{
			Topic = "Perspective",
			Dialogue = "Perspective adds depth. A single vanishing point can make your flat drawing feel alive. Master it for realism.",
		},
		{
			Topic = "Art History",
			Dialogue = "Every artist stands on someone's shoulders. Study masters like Van Gogh or Frida Kahlo—not to copy, but to learn from their choices.",
		},
		{
			Topic = "Digital Tools",
			Dialogue = "Digital tools like Procreate or Photoshop are powerful. Learn layers, brushes, and shortcuts—then let your imagination lead.",
		},
	},
})

--
local MentorDialogueData = {}

function MentorDialogueData:GetData()
	return Data
end

function MentorDialogueData:GetMentorDialoguesData(mentorName: string)
	local mentorData: table = Data[mentorName]

	if not mentorData then
		warn(`Mentor data not found for: {mentorName}`)
	end

	return mentorData
end

function MentorDialogueData:GetMentorDialogueAtIndex(mentorName: string, index: number)
	local mentorData = self:GetMentorDialoguesData(mentorName)

	if mentorData then
		if index < 1 or index > #mentorData then
			warn(`Index out of bounds for mentor dialogue:  .. {mentorName}`)
			return
		end

		return mentorData[index]
	end
end

return MentorDialogueData
