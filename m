From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: overlayfs NFS export
Date: Fri, 7 Apr 2017 21:43:36 +0300
Message-ID: <CAOQ4uxhON5YZSPvoBt2UqGmqQYj3V14C4a=0gC=+v_sVG7S5tQ@mail.gmail.com>
References: <CAOQ4uxhpKFhksVJTgWyy5YRzunLiQjf9TTgFO_EfBSdWvBfxWg@mail.gmail.com>
 <1491577054.10609.1.camel@primarydata.com> <CAJfpegu5hkHM7z4UWhoNhoXBJ9ZmmA8EpAaoThxRe45cCSDeAQ@mail.gmail.com>
 <CAOQ4uxgnvfZUdWfTsPMfjsvht9tEZi04GVyg=VzUNAWHyD=g_A@mail.gmail.com>
 <1491580705.12269.3.camel@primarydata.com> <CAOQ4uxg9MwAffRcwavhRJy+TO9LS=tNKmuy3QHyio5yHGJRN0A@mail.gmail.com>
 <1491582063.12269.7.camel@primarydata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:33271 "EHLO
        mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754489AbdDGSnh (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 7 Apr 2017 14:43:37 -0400
In-Reply-To: <1491582063.12269.7.camel@primarydata.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Trond Myklebust <trondmy@primarydata.com>
Cc: "bfields@fieldses.org" <bfields@fieldses.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "miklos@szeredi.hu" <miklos@szeredi.hu>, "jlayton@poochiereds.net" <jlayton@poochiereds.net>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>

On Fri, Apr 7, 2017 at 7:21 PM, Trond Myklebust <trondmy@primarydata.com> wrote:
> On Fri, 2017-04-07 at 19:10 +0300, Amir Goldstein wrote
>>
>> The most important point to understand is this:
>>
>> If server opens a file for write it will trigger a copy up
>> and the file handle returned will be persistent and final.
>>
>> The only problem is that when server opens a file for
>> read *before* it opens the same file for write, the returned
>> handle would be different, because first open for write
>> creates a new file and the old file remains a zombie
>> (as far as nfsd is concerned) only nfsd is able to to access
>> the old file and only for read.
>
> That will break the client. As Miklos already told you, NFSv3 is
> stateless, so the client won't be sending you an OPEN, and won't
> actually hit a problem until it tries to send a WRITE, in which case
> the resulting ESTALE error will be propagated to the application.
>


Yes, I should have listened to Miklos..
Thanks for taking the time to explain.

Amir.
