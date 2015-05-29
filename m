From: Saied Kazemi <saied@google.com>
Subject: Re: procfs reports unexpected mnt_id and path for overlayfs files
Date: Fri, 29 May 2015 14:29:45 -0700
Message-ID: <CA+Um-gis=3uqHXE6zUd9+CSXzuAkKWB3uWbA+g_zDDGwK8UpMg@mail.gmail.com>
References: <20150415085013.GA8907@odin.com>
	<CAJfpegvKvuu7mtxz+nV1qxpEddf2ZMroBaz+rkFTFVQZ2PoQRw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:34243 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757357AbbE2V3q (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Fri, 29 May 2015 17:29:46 -0400
Received: by oifu123 with SMTP id u123so66152487oif.1
        for <linux-unionfs@vger.kernel.org>; Fri, 29 May 2015 14:29:45 -0700 (PDT)
In-Reply-To: <CAJfpegvKvuu7mtxz+nV1qxpEddf2ZMroBaz+rkFTFVQZ2PoQRw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Andrew Vagin <avagin@odin.com>, CRIU <criu@openvz.org>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Ross Boucher <rboucher@gmail.com>

Hi Miklos,

Is there an update on this patch?  I checked OverlayFS in 4.1-rc5 and
noticed that the issue is still there.

I also observed something interesting/confusing applying this patch to
3.18.  When Docker 1.5 sets up a container, the path into OverlayFS
for a bind mounted file is not visible in /proc/<pid>/mountinfo which
means that the patch has been effective.  But when using Docker 1.7,
the path is visible again.  See below as an example for /etc/hosts:

Using Docker 1.5
# docker run -d busybox:latest ...
# cat /proc/<pid>/mountinfo
...
123 114 8:2 /docker/containers/<container-id>/hosts /etc/hosts
rw,relatime - ext4 /dev/sda2 rw,data=ordered

Using Docker 1.7
# docker run -d busybox:latest ...
# cat /proc/<pid>/mountinfo
...
77 68 8:2 /docker/containers/<container-id>/hosts
/sda2/docker/overlay/<container-id>/merged/etc/hosts rw,relatime -
ext4 /dev/sda2 rw,data=ordered

I verified that the mount system call to set up the container's
filesystem is identical between Docker 1.5 and 1.7.  Any idea as to
what may be causing this problem?

--Saied


On Wed, Apr 15, 2015 at 8:07 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Wed, Apr 15, 2015 at 10:50 AM, Andrew Vagin <avagin@odin.com> wrote:
>> Hello Miklos and Everyone else,
>>
>> We have a report that a container with overlayfs can't be checkpointed.
>>
>> To dump file descriptors we get information from /proc/pid/fd/ and /proc/pid/fdinfo.
>>
>> But in case of overlayfs we see unexpected values there.
>>
>> /proc/PID/fdinfo/FD contains mnt_id which isn't presented in /proc/pid/mountinfo.
>> /proc/PID/fd/FD does not contain an absolute path to the opened file.
>>
>> Can someone help to fix these issues?
>
> See this:
>
> https://lkml.org/lkml/2015/3/20/372
>
> Al didn't like that patch.  But it definitely will be fixed, one way
> or the other, in the near future.
>
> Thanks,
> Miklos
