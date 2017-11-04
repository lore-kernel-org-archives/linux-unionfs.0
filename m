From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: Regression in overlayfs in 4.13: "could not fsync file" error by PostgreSQL
Date: Sat, 4 Nov 2017 12:00:29 +0200
Message-ID: <CAOQ4uxhcWYRcGdwE0QXpZ-_4BFX7LGFyFkFrZSvUgf4PSUFBkg@mail.gmail.com>
References: <20171103140046.h6oabi5tjqqvj6uj@home.ouaza.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f175.google.com ([209.85.161.175]:48749 "EHLO
        mail-yw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751612AbdKDKAa (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 4 Nov 2017 06:00:30 -0400
Received: by mail-yw0-f175.google.com with SMTP id q1so4325790ywh.5
        for <linux-unionfs@vger.kernel.org>; Sat, 04 Nov 2017 03:00:30 -0700 (PDT)
In-Reply-To: <20171103140046.h6oabi5tjqqvj6uj@home.ouaza.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Raphael Hertzog <raphael@ouaza.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>

On Fri, Nov 3, 2017 at 4:00 PM, Raphael Hertzog <raphael@ouaza.com> wrote:
> Hello,
>
> the Kali live image contains PostgreSQL and with our latest image[1]
> PostgreSQL is no longer able to create a new database (/ is an overlayfs
> merging a RO squashfs filesystem and an empty RW tmpfs).
>
> [1] http://cdimage.kali.org/kali-weekly/kali-linux-2017-W43-amd64.iso
> (if 404 look up the parent directory and pick the currently available
> weekly image)
>
> You get messages like this while running createdb:
> createdb: database creation failed: ERROR: checkpoint request failed
> HINT: Consult recent messages in the server log for details.
>
> And in the server log you have this:
> ERROR: could not fsync file "pg_commit_ts": Invalid argument
>
> This was working with Linux 4.12.6 and seems to be broken in Linux 4.13.4
> that we currently have in Kali Linux.
>
> Does this ring a bell to anyone ?

Not really there was a regression with squashfs+overlayfs but it is
fixed in 4.13.4.
(fix false positive ESTALE on lookup)
I tries mounting squashfs+overlayfs to /var/lib/postgresql and create
db on Ubuntu
and it seemed ok.


> I saw a few patches in 4.13.6 but their
> description does not seem to match the error I'm getting.

I don't think those fixes are relevant.

>
> What else can I provide to help you diagnose this issue ?
>
> This bug report has been filed against Kali Linux in the first place:
> https://bugs.kali.org/view.php?id=4332
>

- strace of the failing postgresql db create
- dmesg from that time, specifically "overlayfs" messages
- output of cat /proc/self/mountinfo (or better postgres pid instead of self)

Thanks,
Amir.
