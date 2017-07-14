From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 10/10] ovl: follow decoded origin file handle of merge dir
Date: Fri, 14 Jul 2017 13:58:38 +0300
Message-ID: <CAOQ4uxgBuka1Sz4k5BDWuOxB-p8AH1Vr17pi3bn7xFo57AimZA@mail.gmail.com>
References: <1499777923-29410-1-git-send-email-amir73il@gmail.com>
 <1499777923-29410-11-git-send-email-amir73il@gmail.com> <CAJfpegtk9RiN6cwKXRHoh9i+_tOgYyW+PFkrwEXvit_J9Pm3cw@mail.gmail.com>
 <CAOQ4uxhVCw4BBoNw5O46_yh_TChDy6tp_ahKHnjdui3oVON8iA@mail.gmail.com> <CAJfpegvK8iNJWbM_hbCMGOKey5AOAhP6wtPAOwc2a6ACQf_RXw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:36860 "EHLO
        mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753577AbdGNK6k (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 14 Jul 2017 06:58:40 -0400
Received: by mail-yw0-f196.google.com with SMTP id l21so3286034ywb.3
        for <linux-unionfs@vger.kernel.org>; Fri, 14 Jul 2017 03:58:39 -0700 (PDT)
In-Reply-To: <CAJfpegvK8iNJWbM_hbCMGOKey5AOAhP6wtPAOwc2a6ACQf_RXw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Fri, Jul 14, 2017 at 1:21 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Fri, Jul 14, 2017 at 9:42 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>> On Thu, Jul 13, 2017 at 11:19 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>> On Tue, Jul 11, 2017 at 2:58 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>>>> When inodes index feature is enabled, if lower dir does not match the
>>>> origin fh stored in upper dir, or if no lower dir was found by name,
>>>> try to decode the stored origin fh and use the result as the merge dir
>>>> lower dentry.
>>>>
>>>> This change is needed for indexing of merge directories. A merge
>>>> directory is indexed by the file handle of the uppermost lower dir and
>>>> the index will have a reference to the upper dir by file handle.
>>>> Following down from upper by origin file handle ensures the integrity
>>>> of the index for non-stale origin entries. index entries with stale origin
>>>> are going to be cleaned up on mount anyway.
>>>
>>> Not sure I understand.  In what case is following down by origin needed?
>>>
>>
>> First, a snip from cover letter, parts of it may belong in this commit message:
>>
>> -------->8-------->8-------->8-------->8-------->8-------->8-------->8-------->8
>>
>> Specifically, patches 9-10 introduce a behavior change in the
>> case of changes to lower layer (rename or delete of lower dir).
>> The new behavior is to verify origin fh and try to decode it
>> if verification fails (overlayfs.txt updated).
>>
>> This change in needed for snapshots and I argue in the commit
>> message of patch 10 why it is needed for indexing of directories.
>> I admit that the argument is not rigorous, but since the behavior of
>> changes to lower layer is documented as "undefined", I recon you
>> don't really mind if we change it for index=on.
>
> The behavior is undefined IFF the change is done while the overlay is
> mounted.  Offline modifications are allowed and have defined behavior.

OK. but when NFS client has file handle it changes the rules, because
"offline" modifications are not as "offline" as they use to be.

>
> Now following lower renames is also a defined behavior but it's a
> different defined behavior, so I don't think we should switch to that
> without explicitly opting in.  And I don't think the opt-in has to
> necessarily happen together with indexing.
>
> So I'd argue for a separate mount option (verify_dir was the suggested name?).

Yes, I can bring it back. Not a problem on my end.
My thinking was - indexing is mainly needed for NFS export and NFS export
benefits from verify_dir, so why add another configuration?
Is the use case of using indexing strictly for not breaking hardlinks so
appealing that we should add another dimension to the test matrix?

>
>
>>
>> The rational of making this change in v4.13 as opposed to when
>> directory indexing is implemented, is that index=on already introduces
>> a behavior change related to copying layers, so IMO it is better to
>> introduce all those behavior changes together on index=on.
>>
>> -------->8-------->8-------->8-------->8-------->8-------->8-------->8-------->8
>>
>> My main argument is that 10/10 is needed for snapshots along with patch
>> 9/10 and assuming that you don't object to the change of behavior in 9/10,
>> then perhaps you are ambivalent to this change as well (apparently not).
>
> I missed the fact that 9/10 also changes behavior.  Not good.

Yes, I should have been more loud about this.
The changes to overlay.txt describe this conditional behavior change,
but not the commit message.

>
>> My secondary NFS export related argument goes something like this.
>>
...
>>
>> Feeling any more at ease with this argument?
>
> For NFS export and snapshots this certainly makes sense.  But enabling
> it for index=on by default might not be a good idea, IMO.
>

My intention for NFS export (already scribbled on ovl-nfs-export-wip branch)
was to enable it based on underlying exportfs support AND index=on.
I didn't think that another opt-in config option was in order?

The only justification to merge patches 9,10 to v4.13 is if we want to
bundle hardlinks and NFS export on the same config option, so document
and make all the behavior changes in the same merge cycle and with
the same config option.

If you don't want to bundle index=on with NFS export, then no rush to merge
these patches now. The added benefit on patch 9 (retroactive marking merge
dir with origin for not exposing whiteouts) is relevant to a patch that is not
going to land in v4.13 anyway. right?

Amir.
