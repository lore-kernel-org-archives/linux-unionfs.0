From: Raphael Hertzog <hertzog@debian.org>
Subject: Re: [PATCH 3/3] ovl: redirect on rename-dir
Date: Mon, 7 Nov 2016 14:42:15 +0100
Message-ID: <20161107134215.2v5leafss2mamim5@home.ouaza.com>
References: <1477380887-21333-1-git-send-email-mszeredi@redhat.com>
 <1477380887-21333-4-git-send-email-mszeredi@redhat.com>
 <20161025115748.ydhkkp5cfcdnjzwn@home.ouaza.com>
 <CAJfpegu97ce6LtMeKSHqDxZGAtCJUGgYUwOwYm9P6p8XtNXf_A@mail.gmail.com>
 <CALYGNiN_Hj+4Kf4HJihu5OEkNFU+zzioz5Cc1oHpJ8Wggi0M8Q@mail.gmail.com>
 <20161107110319.7goz3ym3e6fu5lag@home.ouaza.com>
 <CALYGNiP=BjxrU9YLL=bGJ5yXSefGMWEAU8ni23mUipL3frjhzA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALYGNiP=BjxrU9YLL=bGJ5yXSefGMWEAU8ni23mUipL3frjhzA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Miklos Szeredi <mszeredi@redhat.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Guillem Jover <guillem@debian.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Mon, 07 Nov 2016, Konstantin Khlebnikov wrote:
> > Why? (I don't have the feeling that your subsequent paragraphs answer this
> > question... unless "overlayfs mounting is hard, let's complicate it even
> > more" is your answer)
> 
> Mixing flags from mount options, xattrs and emptiness of upper layer
> doesn't make it simpler.

It depends for whom. It does make it simpler for applications that just
want overlayfs to work like other normal filesystems.

> We have clear statement that options in /proc/mounts describes overlay
> instance, let's keep feeding state in this way.

Didn't you say above that xattrs provide flags too?

> > I find it highly disturbing to have to modify all those applications just
> > to get the correct semantics to rename a directory.
> 
> Other application are already aware about overlay layout and use it.
> We cannot enable by default new backward incompatible features.

On the opposite, if we have to modify those applications to add a new
mount option, then they will no longer work with older versions of
overlayfs... so you move the complexity down to applications if they want
to work with multiple kernel versions.

There's no technical problem to enable a new backward incompatible
feature. It's just that you don't want to do it in case the user
wants to mount it again with an older kernel. So this is just policy.

So what about a new mount option that defines a compatibility level?

0: initial feature set
1: with renamedir flag

It would default to 1 but the user can set it to "0" to keep compatibility
with older versions of overlayfs. In the future, as more backward
incompatible changes are added, you add new levels and define the values
of the various flags based on this setting.

> Returning -EXDEV is a completely correct semantics for rename,
> most applications employ broken assumptions about this syscall =)

Maybe (I don't know what standards say), but then what matters is
real-life. And in real-life, it's somewhat unexpected to get back -EXDEV
when the rename() happens in the same directory (and has therefore no
chance to cross any mount boundary).

Cheers,
-- 
Raphaël Hertzog ◈ Debian Developer

Support Debian LTS: http://www.freexian.com/services/debian-lts.html
Learn to master Debian: http://debian-handbook.info/get/
