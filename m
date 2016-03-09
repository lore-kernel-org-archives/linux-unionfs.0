From: =?UTF-8?B?Um9iZXJ0IMWad2nEmWNraQ==?= <robert@swiecki.net>
Subject: Re: GPF in overlay with ovl_rename2
Date: Wed, 9 Mar 2016 13:15:00 +0100
Message-ID: <CAP145pg=-nOBDo+33=BiXu+vcdWmP61QHr6rgJzFPvZBVUU0uA@mail.gmail.com>
References: <CAP145pgRmT4sxxOHYetAQ=q8KgRuMRXLKKJE02jP4AKPCi1zjQ@mail.gmail.com>
	<CAP145pgt7ZJMLn0nzcUuO6G7OhjkLWgEXizGG5d9Uh7wx4ASbg@mail.gmail.com>
	<CAJfpegsHscyjG6ipU_LjqHscyyGBL+CA8J0hrfA-=C+HV3zkwA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-vk0-f47.google.com ([209.85.213.47]:35247 "EHLO
	mail-vk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932301AbcCIMPB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Wed, 9 Mar 2016 07:15:01 -0500
Received: by mail-vk0-f47.google.com with SMTP id e6so52918405vkh.2
        for <linux-unionfs@vger.kernel.org>; Wed, 09 Mar 2016 04:15:01 -0800 (PST)
In-Reply-To: <CAJfpegsHscyjG6ipU_LjqHscyyGBL+CA8J0hrfA-=C+HV3zkwA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

2016-03-09 11:46 GMT+01:00 Miklos Szeredi <miklos@szeredi.hu>:
> On Wed, Jan 13, 2016 at 11:09 PM, Robert =C5=9Awi=C4=99cki <robert@sw=
iecki.net> wrote:
>> Also, text/plain for the list
>>
>> Hi, there seems to be a bug in the overlay which causes a general pa=
ge fault.
>>
>> To replicate I used https://github.com/google/nsjail
>>
>>  I used kernel
>>
>> $ uname -a
>> Linux jag 4.3.0-5-generic #16-Ubuntu SMP Wed Dec 16 23:33:25 UTC 201=
5
>> x86_64 x86_64 x86_64 GNU/Linux
>>
>> $ ./nsjail -T /tmp -Mo --chroot /chroot/ --user 0 --group 0
>> --keep_caps -- /bin/sh -i
>> / # mkdir /tmp/h
>> / # mkdir /tmp/h/w
>> / # mkdir /tmp/h/u
>> / # mkdir /tmp/h/o
>> / # mount -t overlayfs -o
>> lowerdir=3D/bin,upperdir=3D/tmp/h/u,workdir=3D/tmp/h/w overlay /tmp/=
h/o
>> / # cd /tmp/h/o
>> /tmp/h/o # mv sh uuuuu
>> Killed
>>
>> in dmesg
>>
>> [176111.038478] overlayfs: ERROR - failed to whiteout '#ffff880004d9=
ff00'
>
> This seems to be a modified kernel.
>
> Was anything else changed?

Hi,

With:
Linux jag 4.4.0-10-generic #25-Ubuntu SMP Wed Mar 2 14:55:50 UTC 2016
x86_64 x86_64 x86_64 GNU/Linux

It now doesn't induce oops

$ ./nsjail -T /tmp -Mo --chroot /chroot/ --user 0 --group 0
--keep_caps -- /bin/sh -i
/ # mkdir /tmp/h
/ # mkdir /tmp/h/w
/ # mkdir /tmp/h/u
/ # mkdir /tmp/h/o
/ # mount -t overlayfs -o
lowerdir=3D/bin,upperdir=3D/tmp/h/u,workdir=3D/tmp/h/w overlay /tmp/h/o
/ # cd /tmp/h/o
/tmp/h/o # mv sh uuuuu
mv: can't rename 'sh': Value too large for defined data type
/ #

--=20
Robert =C5=9Awi=C4=99cki
