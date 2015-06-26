From: Xu Wang <xuw@redhat.com>
Subject: Re: [overlayfs] lockdep splat after mounting overlayfs over
 overlayfs
Date: Thu, 25 Jun 2015 23:28:20 -0400 (EDT)
Message-ID: <1876235609.31796956.1435289300505.JavaMail.zimbra@redhat.com>
References: <558AD301.4070302@yandex-team.ru> <1919950089.30883798.1435217041129.JavaMail.zimbra@redhat.com> <CALYGNiMPsmjd8Mttom4=-9EnXkvZqstcKaQB-MD1oHCeTzFvow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx4-phx2.redhat.com ([209.132.183.25]:58758 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbbFZD2Z (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 25 Jun 2015 23:28:25 -0400
In-Reply-To: <CALYGNiMPsmjd8Mttom4=-9EnXkvZqstcKaQB-MD1oHCeTzFvow@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>

> On Thu, Jun 25, 2015 at 10:24 AM, Xu Wang <xuw@redhat.com> wrote:
> >> I've accidentally mounted one overlayfs over another and got obvious
> >> warning from lockdep: i_mutex lockdep classes are per-fs-type.
> >>
> >> # mount -t overlay overlay 1 -o
> >> upperdir=1_upper,workdir=1_work,lowerdir=1_lower
> >> # mount -t overlay overlay 2 -o upperdir=2_upper,workdir=2_work,lowerdir=1
> >> # ls 2
> >
> > This reporting is positive, we are not in deadlock situation actually. The
> > "2" dir
> > of overlayfs will call iterate_dir->"1" dir of overlayfs->iterate_dir, and
> > the nest
> > iterate_dir happened on the same file system, so the warning came out.
> >
> > We'd better make the lower and upper in different fs instance, and this
> > warning
> > will disappear.
> >
> > And this lockdep warning happened when the nest iterate_dir call of same
> > fs(I
> > mean the same super block). The function check_deadlock in lockdep.c will
> > report the nest lock of same process. If we make the 2_upper and 2_work in
> > a different fs, no warning comes out.
> 
> Yep, it's not a deadlock. As I mentioned lockdep classes are per-fs-type so
> lockdep cannot see difference between i_mutexes on different sb of the
> same type.
> But anyway this looks messy.
>
 
yes, you are right. The i_mutex_class is file_system_tye scale. I was puzzled by
the debug_locks mechanism during my quick tests. The nest iterate_dir is overlay
dir, neither upper nor lower.

> Probably it's safer to forbid overlayfs as lower or upper mount for overlayfs
> because this have no sense. Nesting anyway is limited by the depth of kernel
> stack and sb->s_stack_depth.
> 
> Or overlayfs could detect this situation and substitute layers of underlying
> overlayfs into its own lower layers in appropriate place.
> 

Can we add the lockdep_off/lockdep_on in this situation? For we know this is
just the false positive reporting of lockdep.


Thanks,

Xu Wang
