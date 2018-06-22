Return-Path: <eddiehorng.tw@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxjBWoRtkic+V412OkZTbTtpkOsNGokyaJWTCEh3pOnNnA@mail.gmail.com>
References: <CALLuPvowiBB7-2aaEgMEyykaZd+Web4zmPPUkx492Wq2CUNhkQ@mail.gmail.com>
 <CAOQ4uxi37A0Nrfhjwc0bxEkrAvjjA47s+aGg6RdOt7J-s0z5BQ@mail.gmail.com>
 <CALLuPvpEzczsFCD_u6+XOxUHY8EWaczYhH-sd=amJGgXsrnd4w@mail.gmail.com>
 <CALLuPvqk3SDWA-GDTworPdgfV=jqeWMUviR5AhYxk+Tc-bUjnw@mail.gmail.com>
 <CAOQ4uxgt41iTTfEgDtYSG=iGLSK9LPR1znBKg_LQYVDwzAG21g@mail.gmail.com>
 <CALLuPvqGdzMWry8m1ewjtecV47uMSCNTPykn954zL42yFDcgRQ@mail.gmail.com>
 <CALLuPvrxjwRwqvfxTTTqZSihTt+DHSBTOMXA9SdHPxnGbJ_yew@mail.gmail.com> <CAOQ4uxjBWoRtkic+V412OkZTbTtpkOsNGokyaJWTCEh3pOnNnA@mail.gmail.com>
From: Eddie Horng <eddiehorng.tw@gmail.com>
Date: Sat, 23 Jun 2018 00:14:31 +0800
Message-ID: <CALLuPvozWF+GDUZToS497E9RB9Figkxn3YND90uhHcM+=xxGvA@mail.gmail.com>
Subject: Re: Invalid argument reading file caps for file
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, Serge Hallyn <serge@hallyn.com>, "Eric W. Biederman" <ebiederm@xmission.com>
List-ID: <linux-unionfs@vger.kernel.org>

> Right, I forgot that unhashing dentry on unlink in an overlayfs thing,
> but that doesn't change my analysis of the problem. You can still get
> an unhashed dentry with ext4 with open_by_handle_at(), just you will
> need to work harder on the reproducer ;-)
>
> This reproducer is plenty enough for reporting the bug and verifying
> the fix.
> Do you intend to send the patch yourself?
> Just include the reproducer in commit message and a phrase along
> the lines of:
>
> The code in cap_inode_getsecurity(), introduced by commit ("Introduce
> v3 namespaced file capabilities"), should use d_find_any_alias() instead
> of d_find_alias() do handle unhashed dentry correctly.  This is needed,
> for example, if execveat() is called with an open but unlinked overlayfs
> file, because overlayfs unhashes dentry on unlink.
>
> You should include a Fixes tag and may include Suggested-by tag.
>

Great to see the root cause is identified now.
Thanks a lot of your analysis, detail explanation and suggestions on this issue.
The solution is about all comes from you, but if you proposed, I'm
glad to finish the rest of patch job.
And really appreciated of your patch suggestion, it makes things much easier.

Thanks,
Eddie
