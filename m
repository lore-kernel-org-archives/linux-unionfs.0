From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 05/11] ovl: lookup redirect by file handle
Date: Fri, 28 Apr 2017 13:45:00 +0300
Message-ID: <CAOQ4uxjmBYWbMCHhedKaOimAmdFvwa1XvM4iR+QG9FN0MSHv4w@mail.gmail.com>
References: <1493025256-27188-1-git-send-email-amir73il@gmail.com>
 <1493025256-27188-6-git-send-email-amir73il@gmail.com> <CAJfpegtz0emDRTHDrq0CrSZXAcovrLAAsX+-WkPGDRbyZD5vOw@mail.gmail.com>
 <CAOQ4uxhu4LVJ-MAjH6McK31MYZ8__RkjCoK31kqJ-7fA2gu+SA@mail.gmail.com>
 <CAOQ4uxiGwd-h2kJVLKkbyBC9YD_a=19ta1HB0F9KueqL_Pr3XA@mail.gmail.com>
 <CAJfpegssdQ4E=uY3bq8zgXLHZsOQaJXpMWtCZ+V=yVM8vmcw5w@mail.gmail.com>
 <CAOQ4uxgPpnnc5dC+PSuOOWdpnobdKZNzgBzmbeW4Lw6P8_--hg@mail.gmail.com>
 <CAJfpeguaePn++tZBvd-2Z68a_8WGfy7EuWLzODyv60E45C6WSQ@mail.gmail.com>
 <CAOQ4uxiozume+xj4KHiDTwqgWmmXKL+6Ksw1EDWXuZYDFa2KVQ@mail.gmail.com>
 <CAJfpegtv4kN4d7ti5f5p=51aQk8U2UT9xdsvZkYoXWOfQ5BNcQ@mail.gmail.com>
 <CAOQ4uxhi4GReBbBzd8NdCJ+emzMEa1COYAtcaKziMiaZAV96uw@mail.gmail.com>
 <CAOQ4uxiGzp2G3qSC7be3nVnvjYJZuHAmY7Q1Oc+jM+pZWtuHig@mail.gmail.com>
 <CAJfpegtAx_KXb6v0dBAD0AJvLeTCFF1X4rfdAptn0xPqRHiLBQ@mail.gmail.com>
 <CAJfpegt9-w_2wQ_Y94w8AcuHYtzJ1fW6n21=eQPbyYqsNawOpQ@mail.gmail.com>
 <CAOQ4uxiweaqzR3eT-StgtDFAHBuYhGRvAJE6v=XpH33MevpmoA@mail.gmail.com>
 <CAJfpegtTJmcLVrLOeQbhu4Q6sM0Mi_FRgr+vStF0k95QsWm5uQ@mail.gmail.com>
 <CAOQ4uxhQFis+uDL9KbiJ87hNU=QRsjHn6O4LShnt6JJFaOtNuA@mail.gmail.com>
 <CAJfpegv4kbUU1+t6+ZApQmnzbOEo-qiHOTy3Dj0Zh84zw9JeUw@mail.gmail.com>
 <CAOQ4uxjkwPwBF7F+Hrf0J_-s1fdCnBPC4wYd04fDtF8wSRaT_Q@mail.gmail.com>
 <CAOQ4uxjGFRXHNNXtyqm0DAdakbSj0yc+sJLcFMmB+VUkMhk0pQ@mail.gmail.com>
 <CAJfpegtXZyX6aubi_TPP_532pb_y+Vv987U08pYkE2SPE0hOuw@mail.gmail.com>
 <CAOQ4uxi6MGAdMqupMsOAuK4NDsJT1ZS1apYXyFpFO_Myy2PRGg@mail.gmail.com>
 <CAJfpegtUXhHyVQV4mszcvrW-SGPYJG+5V40azjusvnRUtAN=8Q@mail.gmail.com>
 <CAOQ4uxj8mzjkkF38tTCPG0_rzV2Ok19c3XjkqNeF56mfiqo9Hg@mail.gmail.com> <CAJfpegsbsjM5zC52_FvEqHEQH+xO_wTcM-=F-gr4+e=Vyt6P2w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:33178 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1422810AbdD1KpC (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 28 Apr 2017 06:45:02 -0400
Received: by mail-io0-f193.google.com with SMTP id k87so10144254ioi.0
        for <linux-unionfs@vger.kernel.org>; Fri, 28 Apr 2017 03:45:01 -0700 (PDT)
In-Reply-To: <CAJfpegsbsjM5zC52_FvEqHEQH+xO_wTcM-=F-gr4+e=Vyt6P2w@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>

On Fri, Apr 28, 2017 at 1:05 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Fri, Apr 28, 2017 at 11:57 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>> On Fri, Apr 28, 2017 at 12:37 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>> On Fri, Apr 28, 2017 at 10:15 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>>>
>>>> Well, we could add configuration options to decide if and how to follow
>>>> and verify fh for non-dir, but:
>>>>
>>>> 1. We agreed that trying to follow fh for non-dir is a no-loose situation
>>>>     for !redirect and hot cache case and a probable win for redirect with
>>>>     cold case
>>>
>>> Okay.  That also means that redirect is not actually needed for
>>> non-dir.  Well, except for the weird case of having to reconstruct a
>>> reverse mapping after copying the layers in order to properly handle
>>> copy up of hardlinks on the lower layer.  But lets not care about that
>>> for now (or ever, probably).
>>>
>>
>> It's needed for when we can't lookup by fh:
>> - lower has NULL uuid
>> - !same_lower_sb (may be relaxed going forward)
>>
>> Heh, it's hard too keep track of it all ;-)
>
> Since this is only for constant inode, we really shouldn't need to
> care about any of the above cases.

It's also going to be needed for preserving hardlinks
(even without copying layers) for !same_fs_with_uuid case.
But that is not fixed by this series, so I can introduce
"redirect non-dir on ovl_link() and ovl_rename()"
in the next series.

>
> Lets keep things as simple as possible.
>

OK, so I'll handle lookup for all layer on samefs with uuid
and leave the rest for later.

And will store overlay.origin in any configuration, which
may be FILEID_INVALID for lowers that don't support exportfs,
so we can make use of it later.

Amir.
