From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v2 05/11] ovl: lookup redirect by file handle
Date: Fri, 28 Apr 2017 09:55:03 +0200
Message-ID: <CAJfpegtXZyX6aubi_TPP_532pb_y+Vv987U08pYkE2SPE0hOuw@mail.gmail.com>
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
 <CAOQ4uxjkwPwBF7F+Hrf0J_-s1fdCnBPC4wYd04fDtF8wSRaT_Q@mail.gmail.com> <CAOQ4uxjGFRXHNNXtyqm0DAdakbSj0yc+sJLcFMmB+VUkMhk0pQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:33067 "EHLO
        mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1164115AbdD1HzF (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 28 Apr 2017 03:55:05 -0400
Received: by mail-io0-f182.google.com with SMTP id k87so53750493ioi.0
        for <linux-unionfs@vger.kernel.org>; Fri, 28 Apr 2017 00:55:05 -0700 (PDT)
In-Reply-To: <CAOQ4uxjGFRXHNNXtyqm0DAdakbSj0yc+sJLcFMmB+VUkMhk0pQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>

On Fri, Apr 28, 2017 at 9:25 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> With all recent conclusions, do you see a reason to keep origin root fh?

No, I'm quite happy if we don't :)

> For snapshots I need just one thing -
> Verify that origin.fh matches the lower of merge dir that was found by path.
> The verification is very cheap (only encode the found dentry), so we may
> do it in any configuration, just don't know how to act upon it.
>
> What to do in case verification fails may need configuration option.
> For snapshots I need a 'strict' policy meaning that "stale lower" equals
> "implicit opaque", but that will not do the right thing for copied layers case.
>
> The way I have it now in my snapshot patches is overload on the redirect_dir
> mount option and add a value redirect_dir=fh. The build time and module
> options are still boolean, but -o redirect_dir=fh sets config->redirect_dir=true
> and config->redirect_fh=true.
> config->redirect_fh can later be set to false if the prerequisite (samefs etc)
> don't apply.
>
> I may need to separate the general ofs->redirect_fh capabiltiy from the mount
> configuration (i.e. config->redirect_dir_fh or make
> config->redirect_dir an enum).
>
> I could also add more policy options for redirect_dir, i.e.:
> off - pre v4.10 compat
> on - v4.10 compat (path only)
> path - same as on, just to explicitly mention for when knowingly copying layers
> fh - snapshot case, fh must be verified
> auto - (the default?) best effort w.r.t lower dir renames -
> lookup by path, verify fh, if fails try to lookup by fh, if fails use
> path result anyway.
>
> I realize you prefer the "minimum configuration" policy, but I'm afraid we
> are at a cross road of letting the user decide. No?

Is this only about dirs though?

For now I'd just add a "verify_lower" option defaulting to off and not
expand "redirect_dir".  That should take care of the snapshot case,
right?

The more complicated things can come later.

Thanks,
Miklos
