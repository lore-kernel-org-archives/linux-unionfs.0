From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: d_path() and overlay fs
Date: Fri, 20 Mar 2015 17:53:52 +0100
Message-ID: <20150320165352.GF20913@tucsk>
References: <20150320132914.GA1749@ws.net.home>
 <CA+5PVA6P3cEy9L+PngXdkVki=x32jZmtPJ2b5oT6SLL=U1NAnw@mail.gmail.com>
 <20150320160123.GE20913@tucsk>
 <20150320162558.GA29656@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:35153 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbbCTQx7 (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Fri, 20 Mar 2015 12:53:59 -0400
Received: by wgdm6 with SMTP id m6so94243088wgd.2
        for <linux-unionfs@vger.kernel.org>; Fri, 20 Mar 2015 09:53:58 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20150320162558.GA29656@ZenIV.linux.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Josh Boyer <jwboyer@fedoraproject.org>, Karel Zak <kzak@redhat.com>, dhowells@redhat.com, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org

On Fri, Mar 20, 2015 at 04:25:58PM +0000, Al Viro wrote:
> On Fri, Mar 20, 2015 at 05:01:23PM +0100, Miklos Szeredi wrote:
> 
> > But it does take care of the majority of f_path users that actually want the
> > covering path.
> 
> Bloody bad idea, IMO.  I have no objections against adding _helpers_ from
> that patch (seq_file_path(), etc.), but I really don't like adding that
> second struct path there.  And it still doesn't fix the issue with
> LSM, etc., so we'll _still_ need to fix it sane way.

Obviously getting rid of the extra path would be good.  But we still have lots
of f_path.dentry in filesystems and we need to start with that.

struct dentry *file_dentry(struct file *) ?  Implemented how?  Rename f_inode to
f_dentry and reimplement file_inode() based on that.

BTW, since nobody is accessing ->f_covering_path directly except the single
f_covering_path() helper, it would be extremely easy to get rid of it later.
That's why I posted this patch, I think it's simple enough to get it into v4.0
which would fix the majority of cases that people complain about.

The thing could even be made dependent on CONFIG_OVERLAY_FS if the addition
actually increases the footprint of struct file (I haven't checked).

Thanks,
Miklos
