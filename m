From: Konstantin Khlebnikov <koct9i@gmail.com>
Subject: Re: [overlayfs] lockdep splat after mounting overlayfs over overlayfs
Date: Thu, 25 Jun 2015 11:21:21 +0300
Message-ID: <CALYGNiMPsmjd8Mttom4=-9EnXkvZqstcKaQB-MD1oHCeTzFvow@mail.gmail.com>
References: <558AD301.4070302@yandex-team.ru>
	<1919950089.30883798.1435217041129.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:33595 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbbFYIVX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 25 Jun 2015 04:21:23 -0400
In-Reply-To: <1919950089.30883798.1435217041129.JavaMail.zimbra@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Xu Wang <xuw@redhat.com>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>

On Thu, Jun 25, 2015 at 10:24 AM, Xu Wang <xuw@redhat.com> wrote:
>> I've accidentally mounted one overlayfs over another and got obvious
>> warning from lockdep: i_mutex lockdep classes are per-fs-type.
>>
>> # mount -t overlay overlay 1 -o
>> upperdir=3D1_upper,workdir=3D1_work,lowerdir=3D1_lower
>> # mount -t overlay overlay 2 -o upperdir=3D2_upper,workdir=3D2_work,=
lowerdir=3D1
>> # ls 2
>
> This reporting is positive, we are not in deadlock situation actually=
=2E The "2" dir
> of overlayfs will call iterate_dir->"1" dir of overlayfs->iterate_dir=
, and the nest
> iterate_dir happened on the same file system, so the warning came out=
=2E
>
> We'd better make the lower and upper in different fs instance, and th=
is warning
> will disappear.
>
> And this lockdep warning happened when the nest iterate_dir call of s=
ame fs(I
> mean the same super block). The function check_deadlock in lockdep.c =
will
> report the nest lock of same process. If we make the 2_upper and 2_wo=
rk in
> a different fs, no warning comes out.

Yep, it's not a deadlock. As I mentioned lockdep classes are per-fs-typ=
e so
lockdep cannot see difference between i_mutexes on different sb of the
same type.
But anyway this looks messy.

Probably it's safer to forbid overlayfs as lower or upper mount for ove=
rlayfs
because this have no sense. Nesting anyway is limited by the depth of k=
ernel
stack and sb->s_stack_depth.

Or overlayfs could detect this situation and substitute layers of under=
lying
overlayfs into its own lower layers in appropriate place.

>
> Thanks,
>
> --
> George Wang =E7=8E=8B=E6=97=AD
>
> Kernel Quantity Engineer
> Red Hat Software (Beijing) Co.,Ltd
> IRC:xuw
> Tel:+86-010-62608041
> Phone:15901231579
> 9/F, Tower C, Raycom
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kerne=
l" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
