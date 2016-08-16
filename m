From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH] overlayfs: Make dir inode always point to the underlay
Date: Tue, 16 Aug 2016 09:37:00 +0200
Message-ID: <CAJfpegugna=PQcNbFHMcKM=Yxtj3eoNSqfKCfxWrJF9rg4o1bw@mail.gmail.com>
References: <4b4580e4-8bec-bfba-cd94-1d531a2f06cc@yunify.com>
 <20160815090815.GH25404@veci.piliscsaba.szeredi.hu> <CAKp8XJ413FtvzCSvCQBbwwwvkF0Kz9mWj31X3igk66oVn-1yoQ@mail.gmail.com>
 <03ef2383-2a24-d88c-a372-d993b80951a4@yunify.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:34859 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbcHPHhC (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Tue, 16 Aug 2016 03:37:02 -0400
Received: by mail-oi0-f46.google.com with SMTP id 4so89082409oih.2
        for <linux-unionfs@vger.kernel.org>; Tue, 16 Aug 2016 00:37:02 -0700 (PDT)
In-Reply-To: <03ef2383-2a24-d88c-a372-d993b80951a4@yunify.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: oc <oc@yunify.com>
Cc: Vito Caputo <vito.caputo@coreos.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, David Howells <dhowells@redhat.com>

On Tue, Aug 16, 2016 at 5:43 AM, oc <oc@yunify.com> wrote:
> Hi Vito,

[Please refrain from top posting, restored]

> =E5=9C=A8 2016=E5=B9=B408=E6=9C=8816=E6=97=A5 08:14, Vito Caputo =E5=86=
=99=E9=81=93:
>>
>> Miklos,
>>
>> Sure, I think the approach of returning the lower layer's ino/dev
>> combination for merged directories should be ok?
>>
>> I guess the one somewhat unexpected behavior/potential down side is
>> st_dev spuriously being different within an overlayfs mount point,
>> things like `find -xdev` or `du -x` won't recurse into directories on
>> the upper layer.

Argh, true.

>>  The advantage of the copying up the directory on
>> getattr was it gave all the directories in the overlay unique inode
>> numbers within a single device.

Yes, directory copy-up on getattr (or lookup) may be the best overall
solution.  I'd do that optionally, and leave copy-up on write the
default as it seems to be OK for most people.

> I am working on solving problem when live migrating container on overlayf=
s,
> and it may also affect
> to your case:
> When live migrating container, either lxc or docker, it use criu to dump =
the
> process.
> If the process has inotify entry (with the pending fix 0955793 in Miklos
> mail), criu need to find the
> file path to inode of inofity entry from scanning files to compare inode =
in
> order to get the file path. It
> is described in https://criu.org/Irmap. Since inofity entry's inode is th=
e
> one for real directory, probably the
> the upper layer, overlayfs need to return the real inode to get criu
> working.

I think overlayfs needs sb->s_export_op filled in.  Together with the
overlayfs fsnotify fix that can ensure that fdinfo will contain a
fhandle consistent with what stat(2) returns, whathever it is.  And
AFAICS that is what lrmap needs to get from a notify handle to a path.

Thanks,
Miklos
