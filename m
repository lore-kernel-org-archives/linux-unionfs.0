Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00E98C4338F
	for <linux-unionfs@archiver.kernel.org>; Mon,  9 Aug 2021 09:21:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D182D60C51
	for <linux-unionfs@archiver.kernel.org>; Mon,  9 Aug 2021 09:21:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234264AbhHIJWJ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 9 Aug 2021 05:22:09 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:13253 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234255AbhHIJWJ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 9 Aug 2021 05:22:09 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4GjrDv0Dsvz1CTwS;
        Mon,  9 Aug 2021 17:21:35 +0800 (CST)
Received: from dggema761-chm.china.huawei.com (10.1.198.203) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 9 Aug 2021 17:21:47 +0800
Received: from [10.174.178.46] (10.174.178.46) by
 dggema761-chm.china.huawei.com (10.1.198.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 9 Aug 2021 17:21:46 +0800
Subject: Re: [QUESTION] Why overlayfs cannot mounted as nfs_export and
 metacopy?
To:     Amir Goldstein <amir73il@gmail.com>
CC:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>
References: <ec78de1b-4edb-1eea-5c0d-79e65f139d79@huawei.com>
 <CAOQ4uxiO7zt7sywNqyd-WwCVds9-NqRAixham9yVeN7F+JhXoA@mail.gmail.com>
 <CAOQ4uxhAGSPKx6xsa5w_Wn9sax8LQQ=dPhB7Dtn1XDwghNpgvg@mail.gmail.com>
From:   Zhihao Cheng <chengzhihao1@huawei.com>
Message-ID: <daca5479-a0fc-10e6-865c-2b1d691905c6@huawei.com>
Date:   Mon, 9 Aug 2021 17:21:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxhAGSPKx6xsa5w_Wn9sax8LQQ=dPhB7Dtn1XDwghNpgvg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.46]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggema761-chm.china.huawei.com (10.1.198.203)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

在 2021/8/8 0:37, Amir Goldstein 写道:
> I remembered some more details...
>
> I think the main complication discussed w.r.t decoding a metacopy
> inode was for the case where ovl_inode_lowerdata() differs from
> ovl_inode_lower().
>
> If we had a weaker variant of metacopy (e.g. metacopy=upper) that
> only allows creating and following metacopy inodes in the upper layer,
> it would have been simpler to implement ovl_obtain_alias().
>
> Specifically, when ofs->numlayer == 2 (single lower layer), there can
> be no valid metacopy inodes in the lower layer, so that configuration
> should also be rather easy to support.
>
> Basically, for ovl_obtain_alias():
> - 'lowerpath' must not have metadata xattr
> - 'upper_alias' must not have metadata xattr
> - If 'index' has metacopy xattr, OVL_UPPERDATA flag
>    should not be set on ovl inode
>
> But there are bigger complications w.r.t disconnected dentry.
> Overlayfs knows how to decode, work with and copy up
> disconnected dentries (parent is unknown), but in ovl_link(old, ...),

Can we get a disconnected non-dir dentry in normal process, or how to 
produce a disconnected dentry?

If I understand correctly, metacopy only inode will be processed in 
ovl_lower_fh_to_d():

706         /* First lookup overlay inode in inode cache by origin fh */
707         err = ovl_check_origin_fh(ofs, fh, false, NULL, &stack);
708         if (err)
709                 return ERR_PTR(err);
710
711         if (!d_is_dir(origin.dentry) ||
712             !(origin.dentry->d_flags & DCACHE_DISCONNECTED)) {
713                 inode = ovl_lookup_inode(sb, origin.dentry, false);
714                 err = PTR_ERR(inode);
715                 if (IS_ERR(inode))
716                         goto out_err;
717                 if (inode) {
718                         dentry = 
d_find_any_alias(inode);                        // A NULL dentry found 
here? How did it happen?
719 iput(inode);
720                         if (dentry)
721                                 goto out;
722 }
723         }

[...]

762         /* Get a connected non-upper dir or disconnected non-dir */
763         dentry = ovl_get_dentry(sb, NULL, &origin, index);      // 
Get disconnected non-dir.

> 'old' dentry must not be a disconnected metacopy dentry when
> calling ovl_set_link_redirect() => ... ovl_get_redirect(), so we will
> also need to:
> - On copy up of a disconnected lower, do not use metacopy
> - Copy up data before ovl_link() when nfs_export is enabled
> - In ovl_obtain_alias(), if 'index' has redirect:
> -- Verify that it is an absolute path that it is resolved to the
> 'lowerpath's inode
> -- oip.redirect needs to be passed to ovl_get_inode()
> -- ovl_verify_inode() needs to verify that oip.redirect matches
>     redirect that is found on existing ovl inode
>
> And probably other things that I am forgetting...
>
> Thanks,
> Amir.
> .


