Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C91A4C4332F
	for <linux-unionfs@archiver.kernel.org>; Sat, 11 Nov 2023 08:04:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbjKKIEH (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 11 Nov 2023 03:04:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbjKKIEH (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 11 Nov 2023 03:04:07 -0500
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [IPv6:2a03:a000:7:0:5054:ff:fe1c:15ff])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1B7C3C0C;
        Sat, 11 Nov 2023 00:04:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
        Content-Type:MIME-Version:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=jDISXaSsB1SihV+ZlT+LjU2yE9U1277TzPJT1ZvBX0U=; b=gJJB1zyVzqjX9fnW2Un+NrhR6H
        mpdXqhAj4Noenj2p0RI7fLryCoHa8j8ivJw+MzQS18WZOI6d5d9FjavHPsnlhSamUtX/VVzUpXXNC
        B63cI4wBbmdfaCG2OcHgsczMn6dVDaxLfbmeq7S9L/wKYgsJK8n9REfHrxoGTrbQMDyEaYRGG80Gh
        q+6kPnYY3gsEVbJAr2Ttbn+nSF3/UACpFl9tWulr9TEyU/sgWrrgtW1DMw+DyqPnFOGfKy8HoQdoj
        XLNsceaW/jCrl/4gaOswA80P36rpbyhqvvbNfXT1F1wAVSez/RjuzZmV/YSrUiDn73YTPQGgJqGAS
        s+bo+Osg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.96 #2 (Red Hat Linux))
        id 1r1iyG-00EDaL-0G;
        Sat, 11 Nov 2023 08:04:00 +0000
Date:   Sat, 11 Nov 2023 08:04:00 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     linux-fsdevel@vger.kernel.org
Cc:     linux-unionfs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <miklos@szeredi.hu>
Subject: [RFC][overlayfs] do we still need d_instantiate_anon() and export of
 d_alloc_anon()?
Message-ID: <20231111080400.GO1957730@ZenIV>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

	AFAICS, the main reason for exposing those used to be the need
to store ovl_entry in allocated dentry; we needed to do that before it
gets attached to inode, so the guts of d_obtain_alias() had to be
exposed.

	These days overlayfs is stashing ovl_entry in the inode, so
we are left with this:
        dentry = d_find_any_alias(inode);
        if (dentry)
                goto out_iput;

        dentry = d_alloc_anon(inode->i_sb);
        if (unlikely(!dentry))
                goto nomem;

        if (upper_alias)
                ovl_dentry_set_upper_alias(dentry);

        ovl_dentry_init_reval(dentry, upper, OVL_I_E(inode));

        return d_instantiate_anon(dentry, inode);

ovl_dentry_init_reval() can bloody well be skipped, AFAICS - all it does
is potentially clearing DCACHE_OP_{,WEAK_}REVALIDATE.  That's also done
in ovl_lookup(), and in case we have d_splice_alias() return a non-NULL
dentry we can simply copy it there.  Sure, somebody might race with
us, pick dentry from hash and call ->d_revalidate() before we notice that
DCACHE_OP_REVALIDATE could be cleaned.  So what?  That call of ->d_revalidate()
will find nothing to do and return 1.  Which is the effect of having
DCACHE_OP_REVALIDATE cleared, except for pointless method call.  Anyone
who finds that dentry after the flag is cleared will skip the call.
IOW, that race is harmless.

And as for the ovl_dentry_set_upper_alias()... that information used to
live in ovl_entry until the need to trim the thing down.  These days
it's in a bit in dentry->d_fsdata.

How painful would it be to switch to storing that in LSB of ovl_entry::__numlower,
turning ovl_numlower() into
	return oe ? oe->__numlower>>1 : 0
and ovl_lowerdata() into
	return lowerstack ? &lowerstack[(oe->__numlower>>1) - 1] : NULL
with obvious adjustment to ovl_alloc_entry().

An entry is coallocated with an array of struct ovl_path, with
numlower elements.  More than 2G layers doesn't seem to be plausible -
there are fat 64bit boxen, but 32Gb (kmalloc'ed, at that) just in
the root ovl_entry alone feels somewhat over the top ;-)

So stealing that bit shouldn't be a problem.  Is there anything I'm
missing?
