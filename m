From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 03/17] ovl: decode pure upper file handles
Date: Wed, 24 Jan 2018 13:55:33 +0200
Message-ID: <CAOQ4uxigw2-hTf0PNjZW8Fw3AHB6TWWjR=FuW46O1U7xaer_-Q@mail.gmail.com>
References: <1515086449-26563-1-git-send-email-amir73il@gmail.com>
 <1515086449-26563-4-git-send-email-amir73il@gmail.com> <CAJfpegt=4Mk7B7E9c7CGJHdWZsVFQAqfJ_NbRNQNOpSZFYudrg@mail.gmail.com>
 <CAOQ4uxg34b6TZ6hwPczv_m_HquR6apnPy0gexHezixMedVqUZA@mail.gmail.com>
 <CAJfpegttoV7aPN2sS6RXONh0eFQ9xyoFxZbzVG7UMCcAJ+zjtg@mail.gmail.com>
 <CAOQ4uxhaC3b2N1rNCBgv0MTyBQgWFZKyVV60VWnudb_wY6A98Q@mail.gmail.com>
 <CAJfpeguVZztckNqML_hJRrEXumMMAeB6+Ha2djPrmCbqXz1brw@mail.gmail.com>
 <CAOQ4uxh0EEuhsLxD3M_xngMd14C=hGb8U12yPe=duELwb4yNDQ@mail.gmail.com>
 <CAOQ4uxhHUaorYA5ZAXQrfaOrp6Xa4cabz+ZFRdVBp6Mf-ebb0g@mail.gmail.com>
 <CAOQ4uxhO+oOGWfSnafNO84GYT0_ihNtR_ekna+DH7rzWMZTgwg@mail.gmail.com>
 <20180119103952.GA24104@veci.piliscsaba.redhat.com> <CAOQ4uxgdww=-R24R4quD4iV0oJ9Wj5WC_-tkvOF_kZgHKa3P5w@mail.gmail.com>
 <CAOQ4uxjKvusKuQP9ACWGQPr3XeT3KskOvj8fQ+L5aEHUB-8n1A@mail.gmail.com>
 <CAJfpegu2WyWFos=ie-T5XRBvZ+=FT8g5T-HsqXSgLS6jxsfYgg@mail.gmail.com>
 <CAOQ4uxh-fjfmKH4oQDNYoi5GYaOFy+QmAb7bsV7urRRABTtjPw@mail.gmail.com> <CAOQ4uxgAFv6iVxmgN8jehPf=7xowd5EDxub8sjJN1b2MWDtOmg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f177.google.com ([209.85.213.177]:45185 "EHLO
        mail-yb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933268AbeAXLze (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 24 Jan 2018 06:55:34 -0500
In-Reply-To: <CAOQ4uxgAFv6iVxmgN8jehPf=7xowd5EDxub8sjJN1b2MWDtOmg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Eryu Guan <eguan@redhat.com>

On Wed, Jan 24, 2018 at 1:18 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Wed, Jan 24, 2018 at 1:04 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> On Wed, Jan 24, 2018 at 12:34 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>> On Fri, Jan 19, 2018 at 9:10 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>>>> On Fri, Jan 19, 2018 at 1:07 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>>>>> On Fri, Jan 19, 2018 at 12:39 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>>>>> On Fri, Jan 19, 2018 at 02:23:35AM +0200, Amir Goldstein wrote:
>>>>>>> > How is this for an option?
>>>>>> [...]
>>>>>>> > +struct dentry *d_obtain_alias_fsdata(struct inode *inode, void **fsdata)
>>>>>>> > +{
>>>>>>> > +       return __d_obtain_alias(inode, 1, fsdata);
>>>>>>> >  }
>>>>>>> >  EXPORT_SYMBOL(d_obtain_alias);
>>>>>>
>>>>>> It would work, but I like this interface better:
>>>>>>
>>>>>> +extern struct dentry * d_alloc_anon(struct super_block *);
>>>>>> +extern struct dentry * d_instantiate_anon(struct dentry *, struct inode *);
>>>>>>
>>>>>
>>>>> OK. Thanks for the patch!
>>>>>
>>>>
>>>> Added your dcache patch to the series and reworked my patches
>>>> to use the new helpers.
>>>>
>>>> Tested result is pushed to:
>>>> https://github.com/amir73il/linux/commits/ovl-nfs-export-v3
>>>>
>>>> Prep patches changes since v2:
>>>> - Rebased over fix patch "hash all directory inodes for fsnotify"
>>>> - Rename mount/config option from "verify" to "nfs_export"
>>>> - Force r/o mount when index dir creation fails
>>>> - Allow enabling "nfs_export" for non-upper mount
>>>> - Require "redirect_dir=nofollow" for non-upper mount
>>>> - Rename dir index entries xattr from ".origin" to ".upper"
>>>> - Re-factor ovl_{get|set|verify}_origin() helpers
>>>> - Simplify test for temp index name (starts with #)
>>>> - Abandon ovl_dentry_is_renamed() test for lower st_ino
>>>> - Document overhead on mount with full index
>>>> - Document change of behavior when verifying lower origin
>>>> - Added patch to make room in ovl_entry struct
>>>>
>>>> NFS export changes since v2:
>>>> - Fix exportfs ops for r/o overlay with no upperdir
>>>> - Document reason for copy up directory on encode
>>>> - Take care of racing with rename while connecting dir
>>>> - Explain the reasons for choosing the 'connected' dir approach
>>>> - Do not add dentry without ovl_entry to dcache
>>>>
>>>> Optimizations TODO:
>>>> - Copy up on encode only when lower ancestor is below middle layer redirect
>>>> - Hash inode by fh to avoid origin decode of whiteout fh
>>>>
>>>> As far as I know, the series is now functionally correct and all comments
>>>> so far addressed. The remaining optimizations will be done on top of this
>>>> series.
>>>
>>> Pushed to overlayfs-next with one fix (do not warn about falling back
>>> to nfs_export=off if nfs_export is already off).
>>
>> Good fix.
>> That warning was a late addition to V3 after allowing nfs_export without
>> index for on-upper r/o mount.
>>
>>>
>>> That spurious warning makes me wonder: how much of the option matrix is tested?
>>>
>>
>> Good question... (adding Eryu in CC)
>>
>> I know Eryu tested with default kernel configuration, because one
>> of my tests found a bug with NFS export and redirect_dir=off.
>> (I fixed the specific test to require redirect_dir)
>>
>> I have posted xfstests for overlay NFS export support with samefs
>> and non-samefs configuration and for non-samefs, there are two
>> lower layers not on the same fs. I also have posted a test for non-upper
>> overlay with two lower layers on samefs and non-samefs.
>>
>> One of the overlay xfstests explicitly turns off index with index=off,
>> (overlay/036), so we have coverage for falling back to nfs_export=off
>> when NFS export is enabled by default (as it usually is in my setup).
>>
>> There is an overlay xfstest with multiple lower layers and no-upper
>> and that test shows the warning about falling back to nfs_export=off
>> due to redirect_dir=nofollow requirement (with default kernel configuration).
>>
>> I did not specifically test underlying fs with no xattr support and no
>> file handle support, though the latter was already tested for index
>> with squashfs (no uuid) and the nfs_export=off code is piggy backed
>> in the same place as index=off.
>>

Correction. no file handle support is covered by nested overlay test
(overlay/029), so I do see those "falling back" warnings as well with v3.
(I did not see the warnings in all my tests because I sometimes apply an
 extra patch to support NFS export on nested overlay).

>
> Clarification: it may be implied when I wrote that "we have test coverage..."
> that there are automatic tests to verify falling back to nfs_export=off.
> This is not the case. I was only listing "falling back" cases whose warning
> I regularly see in my routine overlay/quick xfstest as expected.
>
> Thanks,
> Amir.
