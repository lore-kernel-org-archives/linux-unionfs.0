From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 0/9] overlay: fix inconsistency of ro file after copy-up
Date: Mon, 20 Feb 2017 16:16:04 +0100
Message-ID: <CAJfpegt-2s5v_X9j9wfLwyHNN-FrDjor4R9wM-AgwXdqYWCsYA@mail.gmail.com>
References: <1487347778-18596-1-git-send-email-mszeredi@redhat.com> <20170219091430.GL29622@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:33925 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752707AbdBTPQe (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 20 Feb 2017 10:16:34 -0500
Received: by mail-ot0-f195.google.com with SMTP id w44so1141966otw.1
        for <linux-unionfs@vger.kernel.org>; Mon, 20 Feb 2017 07:16:05 -0800 (PST)
In-Reply-To: <20170219091430.GL29622@ZenIV.linux.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <mszeredi@redhat.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, David Howells <dhowells@redhat.com>, "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@poochiereds.net>

On Sun, Feb 19, 2017 at 10:14 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:

> This is one hell of a DoS vector - it's really easy to eat tons of struct
> file that way.  Preparatory parts of that series make sense on their own,
> but your "let's allocate a struct file, call ->open() and schedule that
> struct file for closing upon the exit to userland on each kernel_read()"
> is not.

Found a couple of instances of this pattern (haven't looked very hard,
possibly there's more):

nfsd_read()
cachefiles_write_page()

How come this hasn't been a problem for them?

Would flush_delayed_fput() work here?  I couldn't really find what the
locking issues with synchronous fputs were.

Thanks,
Miklos
