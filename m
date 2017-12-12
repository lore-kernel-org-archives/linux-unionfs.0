From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [ANNOUNCE] unionmount-testsuite: Amir's master branch updated
Date: Tue, 12 Dec 2017 08:02:55 +0200
Message-ID: <CAOQ4uxgrjxKp-7phO5F5+hSi2drVVoyb9AcFQDj-305m2RjOMA@mail.gmail.com>
References: <CAOQ4uxiiaiq8dettBvZScC59KV-07B-muxE3SS60BDK3dugJow@mail.gmail.com>
 <20171206181700.GA7967@redhat.com> <CAOQ4uxhTWV=ZwDK2DQS2KYux7fufoz0sc7Sv+9dz59gnM1u8+w@mail.gmail.com>
 <CAOQ4uxjM6ZLcyU5-nQXz=T98kuhMrCJ+1df85-19QJQjrr7JiA@mail.gmail.com>
 <20171211195920.GA13399@redhat.com> <CAOQ4uxhb4yVTt29E0XFYY_OT_ubQ5w0Zgqojn=y7nH+XSZ90GA@mail.gmail.com>
 <20171212001021.GR4094@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f172.google.com ([209.85.213.172]:42051 "EHLO
        mail-yb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750731AbdLLGC4 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 12 Dec 2017 01:02:56 -0500
In-Reply-To: <20171212001021.GR4094@dastard>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, David Howells <dhowells@redhat.com>, fstests <fstests@vger.kernel.org>, Chandan Rajendra <chandan@linux.vnet.ibm.com>

On Tue, Dec 12, 2017 at 2:10 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Mon, Dec 11, 2017 at 10:47:15PM +0200, Amir Goldstein wrote:
>> On Mon, Dec 11, 2017 at 9:59 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> > - For the xfs reflink test, I am curious that why have you recommended
>> >   to also enabled "rmapbt=1". Is is required for the tests?
>> >
>>
>> You cannot enable reflink=1 without it.
>
> Yes you can. They are two different functions, used for completely
> different things. They both landed at the same time, will end up
> being fully supported at the same time, and probably get turned on
> by default at the same time. But they are independent options...
>


Thanks for the correction.
I think I'll leave the instructions as is if the features are intended to be
made default at the same time, that is probably the more common setup.

Amir.
