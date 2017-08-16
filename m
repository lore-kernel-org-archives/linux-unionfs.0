From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: two questiones about overlayfs
Date: Wed, 16 Aug 2017 09:52:58 -0400
Message-ID: <20170816135258.GC23045@redhat.com>
References: <b68bea1b-4b51-8573-cf8a-06da4c41ed00@huawei.com>
 <CAOQ4uxiL=Gqy6A=_gKTFG0sQRYkZ37aptdn2fEvcF0phJBmW7Q@mail.gmail.com>
 <20170815133554.GB29201@veci.piliscsaba.szeredi.hu>
 <CAOQ4uxj6qkN-gi4a9ztKJj0FoBMrJC3DPta-m+3dVeHCxZOBNw@mail.gmail.com>
 <CAJfpegsOjqJ-BXFBA3SsuDVornt37GOomP4E8UTaNBxACtGFFw@mail.gmail.com>
 <CAOQ4uxha+B6bpKVxg824-WG-eYxfoL5OxW-PgmcWGcXGe55LXw@mail.gmail.com>
 <CAJfpegv-u+=edQ+bpD-HqAMUYf+Yy-hg-CkVGRiG6VDPT=S7aw@mail.gmail.com>
 <20170815155617.GC3551@redhat.com>
 <CAOQ4uxh4y1AAcQvv_A71E38TAUE9+Zk2vSQisOE1E=QEs7N-Jw@mail.gmail.com>
 <CAJfpegvwXL01-6FPXcbKcPiOKj+LBp69-eHnhiJtuevQdKd4tQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55944 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751556AbdHPNw7 (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 16 Aug 2017 09:52:59 -0400
Content-Disposition: inline
In-Reply-To: <CAJfpegvwXL01-6FPXcbKcPiOKj+LBp69-eHnhiJtuevQdKd4tQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Amir Goldstein <amir73il@gmail.com>, "zhangyi (F)" <yi.zhang@huawei.com>, overlayfs <linux-unionfs@vger.kernel.org>, miaoxie@huawei.com, Theodore Tso <tytso@mit.edu>

On Wed, Aug 16, 2017 at 12:19:22PM +0200, Miklos Szeredi wrote:
> On Tue, Aug 15, 2017 at 6:16 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> > On Tue, Aug 15, 2017 at 5:56 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> 
> >> IIUC, so now "chattr -p <id>" will fail on overlayfs (assume file has not
> >> been copied up yet).
> >>
> >
> > Yap.
> >
> >> IOW, on overlayfs, will it be responsibility of user space to make
> >> sure file has been copied up, for chattr operation to succeed? Does that
> >> mean we need to modify chattr to open file for WRITE instead of READ.
> >>
> >
> > I guess that would make sense.
> > I only wonder what was the reason for chattr to open RDONLY in
> > the first place (cc Ted)??
> 
> What about copy up of flags?  Should we?  Does reflink copy the flags?

Oh yes, copy up of flags seem to be an issue too. I have a file on lower
with project id 123 and once that file gets copied up, project id goes
back to 0.

[merged]# lsattr -p foo.txt 
  123 ------------------- foo.txt

[merged]# touch foo.txt

[merged]# lsattr -p foo.txt 
    0 ------------------- foo.txt

Vivek
