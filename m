From: Saied Kazemi <saied@google.com>
Subject: Re: procfs reports unexpected mnt_id and path for overlayfs files
Date: Mon, 6 Jul 2015 10:45:02 -0700
Message-ID: <CA+Um-gjNDw+nCXZFFTOnPn_LPp4wHMxzLctacT10C3R5+LZrMA@mail.gmail.com>
References: <20150415085013.GA8907@odin.com>
	<CAJfpegvKvuu7mtxz+nV1qxpEddf2ZMroBaz+rkFTFVQZ2PoQRw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:33204 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425AbbGFRpD (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 6 Jul 2015 13:45:03 -0400
Received: by igh16 with SMTP id 16so31356868igh.0
        for <linux-unionfs@vger.kernel.org>; Mon, 06 Jul 2015 10:45:02 -0700 (PDT)
In-Reply-To: <CAJfpegvKvuu7mtxz+nV1qxpEddf2ZMroBaz+rkFTFVQZ2PoQRw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Andrew Vagin <avagin@odin.com>, CRIU <criu@openvz.org>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

Any updates on this?

Thanks,
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
