From: Rock Lee <rockdotlee@gmail.com>
Subject: Re: [PATCH v2 2/4] src/open_by_handle: program to exercise
 open_by_handle_at() syscall
Date: Sat, 22 Apr 2017 15:55:19 +0800
Message-ID: <CAL-1w2vnz0tWHZh4KJnaeaYzN5+=fvfZM6WG2TwcCZsH7WDJZQ@mail.gmail.com>
References: <1492619359-24763-1-git-send-email-amir73il@gmail.com> <1492619359-24763-3-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f174.google.com ([209.85.213.174]:33245 "EHLO
        mail-yb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1042885AbdDVHzV (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 22 Apr 2017 03:55:21 -0400
In-Reply-To: <1492619359-24763-3-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Eryu Guan <eguan@redhat.com>, Trond Myklebust <trondmy@primarydata.com>, Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, David Howells <dhowells@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, fstests@vger.kernel.org, linux-unionfs@vger.kernel.org

Hi, Amir:

> +       /*
> +        * now drop the caches so that unlinked inodes are reclaimed and
> +        * buftarg page cache is emptied so that the inode cluster has to be
> +        * fetched from disk again for the open_by_handle() call.
> +        */
> +       ret = system("echo 3 > /proc/sys/vm/drop_caches");
> +       if (ret < 0) {
> +               perror("drop_caches");
> +               return EXIT_FAILURE;
> +       }
> +

The original value of  /proc/sys/vm/drop_caches is 0 in my rpi3. After
this test, it turns to 3. Is it necessary to restore it ?

-- 
Cheers,
Rock
