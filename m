From: "Klaus Kreil" <klaus.kreil@univie.ac.at>
Subject: Re: overlayfs v22 on kernel 3.15.5
Date: Wed, 23 Jul 2014 14:15:21 +0200
Message-ID: <cea39652198f0108e2a026450bd74c7b.squirrel@webmail.univie.ac.at>
References: <CAJfpeguH=BmevY+SM8HKBATS7B+htcX7_WLRiMFmypW_D-424Q@mail.gmail.com>
    <3a4b4cc25d1a8325934ba439d4777c35.squirrel@webmail.univie.ac.at>
    <CAJfpegs1_iTJJGvLddyF=-L9YreVCzbDL-Pum70FTO6W+MvozQ@mail.gmail.com>
    <CAJfpegubZyar3JxYg7OxFVa1O3xWoMqaHiRUS_eME_OCzv6QFA@mail.gmail.com>
    <207df75d465c4b3fe95b6a90f3531905.squirrel@webmail.univie.ac.at>
    <CAJfpegsc4swQ2e7LfKbzHYCoa3thvetLhydzqr1My2PJr=Myag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from grace.univie.ac.at ([131.130.3.115]:49790 "EHLO
	grace.univie.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbaGWMPY (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Wed, 23 Jul 2014 08:15:24 -0400
In-Reply-To: <CAJfpegsc4swQ2e7LfKbzHYCoa3thvetLhydzqr1My2PJr=Myag@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Klaus Kreil <klaus.kreil@univie.ac.at>, linux-unionfs@vger.kernel.org

On Mi, 23.07.2014, 14:02, Miklos Szeredi wrote:
> On Wed, Jul 23, 2014 at 1:57 PM, Klaus Kreil <klaus.kreil@univie.ac.at>
> wrote:
>
>>> You need to give absolute paths:
>>>
>>> mount -t overlayfs overlayfs -o
>>> lowerdir=/mnt/root_ro,upperdir=/mnt/root_rw/upper,workdir=/mnt/root_rw/work
>>> /mnt/root
>>>
>> Thanks Miklos,
>> I had tried that before, but that did not/does not work as well. The new
>> command (adjusted to my environment and from within the rescue-shell and
>> all within a single line) was:
>> # mount -t overlayfs overlayfs -o
>> lowerdir=/mnt/root_ro,upperdir=/mnt/root_rw,workdir=/mnt/root_rw/.work
>> /mnt/root
>>
>> The new error message from dmesg now reads:
>> [ 1369.069178] overlayfs: workdir and upperdir must be separate subtrees
>
> Exactly. Observe that I used upperdir=/mnt/root_rw/upper.
I see what you mean and I have to admit, that slipped my eye.

This however triggers an additional question: Would this now require me to
create an new "virtual" root directory (in your case named "upper") on my
upperdir filesystem and move everything that was in the real root of the
existing upperdir filesystem to the new virtual root directory?
In other words now - and contrary to the old behaviour - overlaying one
root directory of a filesystem onto another root directory of another
filesystem is no longer possible.

If that's the case, I guess lost+found should nevertheless stay in the
real root directory of the upperdir?

Furthermore that would als mean that the workdir is never visible from
within the combined tree and therefore I could go away with the .work and
rename the workdir to work.

Thanks again for your help,

Klaus

