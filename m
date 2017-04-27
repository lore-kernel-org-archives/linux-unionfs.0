From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 05/11] ovl: lookup redirect by file handle
Date: Thu, 27 Apr 2017 12:22:30 +0300
Message-ID: <CAOQ4uxjztbvMFmJTumfJH=S-SZ0mJUMfLV1UD-M4-sY23n5Lrg@mail.gmail.com>
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
 <CAOQ4uxiGzp2G3qSC7be3nVnvjYJZuHAmY7Q1Oc+jM+pZWtuHig@mail.gmail.com> <CAJfpegtAx_KXb6v0dBAD0AJvLeTCFF1X4rfdAptn0xPqRHiLBQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:36701 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1032291AbdD0JWb (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 27 Apr 2017 05:22:31 -0400
In-Reply-To: <CAJfpegtAx_KXb6v0dBAD0AJvLeTCFF1X4rfdAptn0xPqRHiLBQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Thu, Apr 27, 2017 at 10:48 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Thu, Apr 27, 2017 at 8:27 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>
>> Let me try to explain the problem with a worse case, but not
>> improbable example:
>>
>> Suppose I have an overlay with deep file at /a/b/c/.../z
>> Suppose the layers are at /old/{lower,upper} I copy them
>> over to /new/{lower,upper} and mount the overlay at new path.
>>
>> Suppose that dcache is fully populated under /new and fully
>> evicted under /old.
>>
>> When trying to decode the file handle for z, exportfs_decode_fh()
>> will call the file system to actually read all directories a..z from disk
>> in order to reconnect the dentry of old z all the way up to /old
>> and it will do that *before* calling the acceptable() callback.
>>
>> Alternatively, if we first try to decode the file handle for /old/lower,
>> decoding will be very fast (most likely already in cache) and we will
>> not have to continue to decoding z and reading all directories a..z
>> from disk.
>
> To answer my own question in the prev mail: we need to decode the fh
> and not just blindly use the inum to prevent issues with
> copied/mutilited/etc lower layers.
>

I was going to refer you to this example when reading you question
in prev email. That's what we get for no read/write barriers in emails ;-)

> And yes, in the copied case decoding origin.root first would be a good
> optimization that couldn't be done without it.
>

Good, so we seem to have an agreement w.r.t. the lookup fh patch.

I've already applied a change to disable redirect_fh if lower s_uuid is
zeros and I verified that it works as expected by running the hard-link
constant inode test that relies on redirect_fh over xfs mounted with
-o nouuid.

I will be posting the enhanced xfstest for constant inodes later today.

Let me know when are are done reviewing the series, so I can rework it
with the binary blob change you requested.

Thanks,
Amir.
