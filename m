Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BD62C433DB
	for <linux-unionfs@archiver.kernel.org>; Mon,  8 Mar 2021 23:50:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCD0E65256
	for <linux-unionfs@archiver.kernel.org>; Mon,  8 Mar 2021 23:50:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbhCHXuN (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 8 Mar 2021 18:50:13 -0500
Received: from vulcan.kevinlocke.name ([107.191.43.88]:46584 "EHLO
        vulcan.kevinlocke.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbhCHXuB (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 8 Mar 2021 18:50:01 -0500
Received: from kevinolos.kevinlocke.name (host-69-145-60-23.bln-mt.client.bresnan.net [69.145.60.23])
        (Authenticated sender: kevin@kevinlocke.name)
        by vulcan.kevinlocke.name (Postfix) with ESMTPSA id 3B94E21033FF;
        Mon,  8 Mar 2021 23:50:00 +0000 (UTC)
Received: by kevinolos.kevinlocke.name (Postfix, from userid 1000)
        id E09DE1300670; Mon,  8 Mar 2021 16:49:57 -0700 (MST)
Date:   Mon, 8 Mar 2021 16:49:57 -0700
From:   Kevin Locke <kevin@kevinlocke.name>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
Subject: Re: [PATCH] ovl: add xino to "changes to underlying fs" docs
Message-ID: <YEa4Jd0VE6w4T7/v@kevinlocke.name>
Mail-Followup-To: Kevin Locke <kevin@kevinlocke.name>,
        Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
References: <CAOQ4uxj4zNHU49Q6JeUrw4dvgRBumzhtvGXpuG4WDEi5G7uyxw@mail.gmail.com>
 <b36a429d7c563730c28d763d4d57a6fc30508a4f.1615216996.git.kevin@kevinlocke.name>
 <CAOQ4uxhGSbEPPwZswXHq+k1YF=+ntDfukxnfGsJ3+RaGjgNDnQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhGSbEPPwZswXHq+k1YF=+ntDfukxnfGsJ3+RaGjgNDnQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi Amir,

On Mon, 2021-03-08 at 19:41 +0200, Amir Goldstein wrote:
> On Mon, Mar 8, 2021 at 5:23 PM Kevin Locke <kevin@kevinlocke.name> wrote:
>> Add "xino" to the list of features which cause undefined behavior for
>> offline changes to the lower tree in the "Changes to underlying
>> filesystems" section of the documentation to make users aware of
>> potential issues if the lower tree is modified and xino was enabled.
>>
>> This omission was noticed by Amir Goldstein, who mentioned that xino is
>> one of the "forbidden" features for making offline changes to the lower
>> tree and that it wasn't currently documented.
> 
> [...]
> When looking again, I actually don't see a reason to include "xino"
> in this check at all (not xino=on nor xino=auto):
> 
>  if (!ofs->config.index && !ofs->config.metacopy && !ofs->config.xino &&
>      uuid_is_null(uuid))
>          return false;
> 
> The reason that "index" and "metacopy" are in this check is because
> they *need* to follow the lower inode of a non-dir upper in order to
> operate correctly. The same is not true for "xino".
> 
> Moreover, "xino" will happily be enabled also when lower fs does not
> support file handles at all. It will operate sub-optimally, but it will live up
> to the promise to provide a unified inode namespace and uniform st_dev.

Good observation!  I think you are right.  After a bit of testing, I did
not notice any issues after making offline changes to lower with xino
enabled.

> Note that "redirect_dir" is not one of the "forbidden" features.

To be clear, are you saying that offline modifications to directories in
lower layers which are the redirection target of an upper layer does not
cause undefined behavior?  Would it make sense for me to work up a patch
which documents the behavior, or is it better to leave as "defined but
undocumented"?

My understanding of the current behavior:

1. If a redirection target dir is removed from lower, contents which do
   not exist in any upper are removed from the redirected dir in the
   overlay.  Contents which exist in an upper are unchanged.
2. If a redirection target dir is renamed in lower, it has the same
   effect as removing the directory with the old name and creating one
   with the new name and contents.
3. Permission changes to a redirection target dir have no effect in the
   overlay.
4. If a previously removed redirection target dir is created, its
   contents are added to the redirected dir in the overlay, unless the
   redirected dir had been renamed after removal, in which case it is
   ignored (because the redirected dir becomes opaque when renamed).
5. If a file with the name of a previously removed redirection target
   dir is created, it is ignored.

The only behavior which seems a bit surprising to me is #4:  If
directory B in upper is redirected to A in lower and A is subsequently
removed, then (possibly years later) a directory named A is created, its
contents would appear in B in the overlay.  However, if B had been
renamed to C after A was removed, it becomes opaque, causing A and its
contents not to appear in the overlay.  Either of these may surprise
users.

Does that match your understanding of the current behavior?  Worth
documenting or better to just remove redirect_dir from the list of
features where offline modification causes undefined behavior?

Thanks,
Kevin
