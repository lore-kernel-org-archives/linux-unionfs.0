From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v4 00/15] overlayfs constant inode numbers
Date: Thu, 4 May 2017 11:15:17 +0200
Message-ID: <CAJfpeguVxbEQLqnz6t1sjbG5J5hWpqgqOw7qdtEZGSxd7j+y4A@mail.gmail.com>
References: <1493646126-10101-1-git-send-email-amir73il@gmail.com>
 <CAJfpegs4SnbHVTa43Wy9R=_3XRMwwnXN9SCKCpq42F-19g9LnQ@mail.gmail.com>
 <CAOQ4uxi4sjY=q4q=kU7vtJEKASUwO9DE3Xa61GMe9wEOHQ-f1g@mail.gmail.com>
 <CAOQ4uxgprhDhRzWyTEYUaYKdvUeYWNSafreu1r3TA-2r7xg-aA@mail.gmail.com> <CAJfpegss1jrd0LZkCOkaiQe06ECwH0atneVg3xa_YWXiG4UDOw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:34553 "EHLO
        mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753875AbdEDJPT (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 4 May 2017 05:15:19 -0400
Received: by mail-io0-f179.google.com with SMTP id k91so14625536ioi.1
        for <linux-unionfs@vger.kernel.org>; Thu, 04 May 2017 02:15:18 -0700 (PDT)
In-Reply-To: <CAJfpegss1jrd0LZkCOkaiQe06ECwH0atneVg3xa_YWXiG4UDOw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

One more little detail: file handle byte order.  We store the fh in a
filesystem, which means it can be used by systems with different
endianness, which basically invalidates it. This scenario is highly
unlikely to happen in practice, so for simplicity perhaps we should
just store a bit into the origin structure indicating the byte order
used to create the file handle and verify it when using it.

Thoughts?

Thanks,
Miklos
