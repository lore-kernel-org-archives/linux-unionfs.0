From: Linas Vepstas <linasvepstas@gmail.com>
Subject: Re: LXC+overlayfs in unprivileged mode
Date: Sun, 1 Jan 2017 14:32:20 -0600
Message-ID: <CAHrUA3575TN8g9xZYrxShapjXy9M1ZWn8BEeZkK65zUJuPOffw@mail.gmail.com>
References: <CAHrUA37sR6ea6UNJZjbAHPWwkoTbtEg7Uq8Z1war9ODA23qcSw@mail.gmail.com>
 <CAOQ4uxi51_0C_-YVz_UYUbOWW3rSjmKv4NUkyxq0oCaWexZ6hw@mail.gmail.com>
Reply-To: linasvepstas@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:35117 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932342AbdAAUcl (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 1 Jan 2017 15:32:41 -0500
In-Reply-To: <CAOQ4uxi51_0C_-YVz_UYUbOWW3rSjmKv4NUkyxq0oCaWexZ6hw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>, Seth Forshee <seth.forshee@canonical.com>, "Eric W. Biederman" <ebiederm@xmission.com>

Ah, thanks!

On Sun, Jan 1, 2017 at 2:51 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Sat, Dec 31, 2016 at 7:42 PM, Linas Vepstas <linasvepstas@gmail.com> wrote:

>> I tripped across an LXC bug that actually appears to be an overlayfs
...
>> the situation is confusing.
>>
>
> The foundations for mount from unprivileged user namespace were merged
> to kernel v4.8, you can read more about it in Eric's pull request:
> https://lkml.org/lkml/2016/7/26/297
>
> Seth Forshee was working on these vfs changes to allow fuse mount in
> unprivileged user namespace:
> https://lwn.net/Articles/685239/
>
> Not sure about the status of the work on fuse mount?
>>
>> Any advice on how to proceed?
>
> Not sure what you want to achieve?

I wanted to understand why things half-work, and figure out where to
report a bug, if that's what needed to be done.   But based on what
you wrote, I conclude that its "work in progress", and from a user
perspective, I can kick back and wait.  I guess some LXC wiki
somewhere should be updated to state that user-space containers
require kernel version xyz or patch pqr.

It's somehow ironic that the push for user-space mounts and containers
comes from this general fuzzy sensation that they are somehow "safer",
yet the changes to enable this provide a new attack surface for
privilege escalation. Funny world we live in. :-)  Happy New Year!

--linas
