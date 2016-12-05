From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] overlay: test ro/rw fd data inconsistecies
Date: Mon, 5 Dec 2016 09:01:57 +0200
Message-ID: <CAOQ4uxgcJvfC1DuZ25oiZ680TbrsiYckma_aeiJH4hFE+=UiWw@mail.gmail.com>
References: <1480018332-16567-1-git-send-email-amir73il@gmail.com>
 <CAOQ4uxgEgNJtFfauUTXAr9YedbJeNFrZaWAUbEJUzycf=r3Emw@mail.gmail.com>
 <20161129113715.GN22989@eguan.usersys.redhat.com> <CAOQ4uxjSZuKocjcLdn6eWmJJdRqYrXonoq0Czvk-UCH6aWfseA@mail.gmail.com>
 <20161202064954.GI11750@dastard> <CAOQ4uxi7UnJPCZS-Vg17=4U+0VPz4BvM0MDcrfaaFG+Y9Z9TgQ@mail.gmail.com>
 <20161204231036.GA21916@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wj0-f195.google.com ([209.85.210.195]:35192 "EHLO
        mail-wj0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752031AbcLEHCA (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 5 Dec 2016 02:02:00 -0500
In-Reply-To: <20161204231036.GA21916@dastard>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Eryu Guan <eguan@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests <fstests@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Mon, Dec 5, 2016 at 1:10 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Fri, Dec 02, 2016 at 10:13:33AM +0200

...
>
> ... it's just an unexpected interaction with common functionality
> provided by libxcmd that is present to support xfs_quota
> requirements, not xfs_io. Hence there's every chance that it's use
> in xfs_io is simply incorrect and never intended, and you're the
> first person to ever trip over it.
>
> The solution may simply be that we add CMD_FLAG_GLOBAL to
> every command in xfs_io, but I'm not sure yet.
>
>> If you have a preference for solution I can execute the work.
>
> Always fix the broken tool first.
>

The question was if I need to fix the run command per file or kill it.

Anyway, I came up with a very simple patch that enabled running
xfs_io -c <cmd> without any <file> args.
In that case, it is easy to understand what the user wants and commands
are just run once as if they where input in the interactive shell.

This is good enough for my test case and should be a good change
for xfs_io all in all.

Patch on its way.

I will let you decide how to handle the undocumented/unused/broken
case of multiple files and "open" command.

Amir.
