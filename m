From: Konstantin Khlebnikov <koct9i@gmail.com>
Subject: Re: [PATCH 3/3] ovl: redirect on rename-dir
Date: Fri, 11 Nov 2016 12:46:28 +0300
Message-ID: <CALYGNiP+Sv40_HODSppgYr-puAzBupFWa9TJxHTLo9yA-ARE=A@mail.gmail.com>
References: <1477380887-21333-1-git-send-email-mszeredi@redhat.com>
 <1477380887-21333-4-git-send-email-mszeredi@redhat.com> <20161025115748.ydhkkp5cfcdnjzwn@home.ouaza.com>
 <CAJfpegu97ce6LtMeKSHqDxZGAtCJUGgYUwOwYm9P6p8XtNXf_A@mail.gmail.com>
 <CALYGNiN_Hj+4Kf4HJihu5OEkNFU+zzioz5Cc1oHpJ8Wggi0M8Q@mail.gmail.com>
 <CAJfpegvzsjWBL5nu7SQt2kp7efjGMpb9L2JMxzXPXUTdDnft0Q@mail.gmail.com>
 <CALYGNiOfcuM55458mZoUd4r789z7nVs7Yj0vAA5Qo=BetTJA0Q@mail.gmail.com>
 <CAJfpeguB-RRFbuwy=csPxoByKC=FTxYyuvnm+rmfTUmkVX+K9w@mail.gmail.com>
 <CALYGNiMXhvGOq0P-NG_1jMyN7qp+1+UJ8qihp6wVr0xAKjNHsQ@mail.gmail.com>
 <CAOQ4uxgzwh55eM19ebfKv6+F8gyHJTN1QRK6R9qALUGmFd1k0g@mail.gmail.com> <CAOQ4uxiqT0xrARYUUR4BtE9RTdGD+-qTq0Mbs94Tv6NWe5Gm9Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAOQ4uxiqT0xrARYUUR4BtE9RTdGD+-qTq0Mbs94Tv6NWe5Gm9Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Raphael Hertzog <hertzog@debian.org>, Miklos Szeredi <mszeredi@redhat.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Guillem Jover <guillem@debian.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Fri, Nov 11, 2016 at 1:56 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Mon, Nov 7, 2016 at 3:38 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> On Mon, Nov 7, 2016 at 12:08 PM, Konstantin Khlebnikov <koct9i@gmail.com> wrote:
>>> On Mon, Nov 7, 2016 at 1:04 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>>> On Mon, Nov 7, 2016 at 10:58 AM, Konstantin Khlebnikov <koct9i@gmail.com> wrote:
>>>>
>>>>> I've stumbled on somehow related problem - concurrent copy-ups are
>>>>> strictly serialized by rename locks.
>>>>> Obviously, file copying could be done in parallel: locks are required
>>>>> only for final rename.
>>>>> Because of that overlay slower that aufs for some workloads.
>>>>
>>>> Easy to fix: for each copy up create a separate subdir of "work".
>>>> Then the contention is only for the time of creating the subdir, which
>>>> is very short.
>>>
>>> Yeah, but lock_rename() also takes per-sb s_vfs_rename_mutex (kludge by Al Viro)
>>> I think proper synchronization for concurrent copy-up (for example
>>> round flag on ovl_entry) and  locking rename only for rename could be
>>> better.
>>
>> Removing s_vfs_rename_mutex from copy-up path is something I have been
>> pondering about.
>> Assuming that I understand Al's comment above vfs_rename() correctly,
>> the sole purpose of per-sb serialization is to prevent loop creations.
>> However, how can one create a loop by moving a non-directory?
>> So it looks like at least for the non-dir copy up case, a much finer grained
>> lock is in order.
>>
>
>
> I posted patches to relax the s_vfs_rename_mutex for copy-up and
> whiteout in some use cases.
>
> Konstantin,
>
> It would be useful to know if those patches help with your use case.
>

Well.. I think relaxing only s_vfs_rename_mutex wouldn't help much here.
Copying is still serialized by i_mutex on workdir?
Data copying should be done without rename locks at all.
