# How I got started

Within the entire development team at Artsy, the iOS team was unique in that it didn't write tests. This is in part due to the issues around tooling, horror stories about lost productivity and a lack of non-trivial examples.

The other part was that no-one else was doing it when they were a small team. You would hear about large companies with tens of employees creating a large testing structure, but very few small startups with a couple of programmers were talking about testing.

We had experimented once or twice with adding testing to our applications, mainly doing Integration Testing with [KIF]((https://github.com/square/kif), but without team consensus the attempts fell flat.

At the end of 2013 the [Bus Factor](http://en.wikipedia.org/wiki/Bus_factor) for all of the knowledge in the Artsy mobile apps became an all-time low.

I was the only one with any knowledge of how our systems worked  and what additional context anyone needed to know about making changes. I had been involved in all decisions, and all that domain knowledge was just in me.

So, the mobile team expanded. Laura Brown and dB joined the mobile team from the web side. They helped raise our testing standards. From close-to zero, to something.

These changes in our development culture helped turn a pretty insular team, into one that's world-renowned for it's documentation and accessibility of it's code-bases. We actively use blog-posts, videos and conference talks to document why and how things work in our team.

When new members join, they have a wide variety of sources to understand how the team work, including this book - which helps to explain a lot of the decisions we made around testing methodologies and internal best-practices.

Finally, I write tests because some day I will leave Artsy. I don't want those who have to continue the apps to remember me as the person who left a massive pile of hard-to-maintain code. Just little bits of that here and there, and the majority reasonably explained.
