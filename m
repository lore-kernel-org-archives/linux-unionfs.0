From: Konstantin Khlebnikov <koct9i@gmail.com>
Subject: Re: [PATCH 3/3] ovl: redirect on rename-dir
Date: Mon, 7 Nov 2016 13:08:27 +0300
Message-ID: <CALYGNiMXhvGOq0P-NG_1jMyN7qp+1+UJ8qihp6wVr0xAKjNHsQ@mail.gmail.com>
References: <1477380887-21333-1-git-send-email-mszeredi@redhat.com>
 <1477380887-21333-4-git-send-email-mszeredi@redhat.com> <20161025115748.ydhkkp5cfcdnjzwn@home.ouaza.com>
 <CAJfpegu97ce6LtMeKSHqDxZGAtCJUGgYUwOwYm9P6p8XtNXf_A@mail.gmail.com>
 <CALYGNiN_Hj+4Kf4HJihu5OEkNFU+zzioz5Cc1oHpJ8Wggi0M8Q@mail.gmail.com>
 <CAJfpegvzsjWBL5nu7SQt2kp7efjGMpb9L2JMxzXPXUTdDnft0Q@mail.gmail.com>
 <CALYGNiOfcuM55458mZoUd4r789z7nVs7Yj0vAA5Qo=BetTJA0Q@mail.gmail.com> <CAJfpeguB-RRFbuwy=csPxoByKC=FTxYyuvnm+rmfTUmkVX+K9w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:33265 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752240AbcKGKIa (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 7 Nov 2016 05:08:30 -0500
In-Reply-To: <CAJfpeguB-RRFbuwy=csPxoByKC=FTxYyuvnm+rmfTUmkVX+K9w@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Raphael Hertzog <hertzog@debian.org>, Miklos Szeredi <mszeredi@redhat.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Guillem Jover <guillem@debian.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Mon, Nov 7, 2016 at 1:04 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Mon, Nov 7, 2016 at 10:58 AM, Konstantin Khlebnikov <koct9i@gmail.com> wrote:
>
>> I've stumbled on somehow related problem - concurrent copy-ups are
>> strictly serialized by rename locks.
>> Obviously, file copying could be done in parallel: locks are required
>> only for final rename.
>> Because of that overlay slower that aufs for some workloads.
>
> Easy to fix: for each copy up create a separate subdir of "work".
> Then the contention is only for the time of creating the subdir, which
> is very short.

Yeah, but lock_rename() also takes per-sb s_vfs_rename_mutex (kludge by Al Viro)
I think proper synchronization for concurrent copy-up (for example
round flag on ovl_entry) and  locking rename only for rename could be
better.
