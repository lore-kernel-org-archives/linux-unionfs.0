Return-Path: <SRS0=Ys2z=CK=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 746A4C433E7
	for <linux-unionfs@archiver.kernel.org>; Tue,  1 Sep 2020 14:12:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47937207D3
	for <linux-unionfs@archiver.kernel.org>; Tue,  1 Sep 2020 14:12:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Hobx2Xmr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728276AbgIAOMP (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 1 Sep 2020 10:12:15 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:38982 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727986AbgIANPU (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 1 Sep 2020 09:15:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598966097;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4A31Kahj7lTitdZxz/e2jAalf40L1bTKKwkZPz5ial8=;
        b=Hobx2XmrJcvX4gR6jdhuXmUWsQSRsZovocg4sx2ZtMS8Rv1KnnKScTGSbIr2lbqRiKjahd
        QEc1glKNZWddxmPuUluU4QunQ2PJVjsvBIbcKv2I7jgedVxFK8jj1KUekTZ6MGidvH2icd
        4L+1W99O+tKhUWmTDgPPTf9kwuD7EeI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-283-cg4t-LoJMhOJMKFhEzKaxw-1; Tue, 01 Sep 2020 09:14:53 -0400
X-MC-Unique: cg4t-LoJMhOJMKFhEzKaxw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EC10B18A2247;
        Tue,  1 Sep 2020 13:14:51 +0000 (UTC)
Received: from horse.redhat.com (ovpn-116-208.rdu2.redhat.com [10.10.116.208])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 265621002D50;
        Tue,  1 Sep 2020 13:14:51 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id A5ACD22053E; Tue,  1 Sep 2020 09:14:50 -0400 (EDT)
Date:   Tue, 1 Sep 2020 09:14:50 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Daniel J Walsh <dwalsh@redhat.com>
Subject: Re: [PATCH v7] overlayfs: Provide a mount option "volatile" to skip
 sync
Message-ID: <20200901131450.GA1218147@redhat.com>
References: <20200831181529.GA1193654@redhat.com>
 <CAOQ4uxi6Hc4gNwCiogBG+FeeW-bAUd-ZsW2X=TPJ+6JZCbodVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxi6Hc4gNwCiogBG+FeeW-bAUd-ZsW2X=TPJ+6JZCbodVQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Sep 01, 2020 at 11:22:26AM +0300, Amir Goldstein wrote:
[..]
> 
> > +       int nr_elems = ARRAY_SIZE(dirty_path);
> > +
> > +       err = 0;
> > +       parent = ofs->workbasedir;
> > +       dget(parent);
> > +
> > +       for (i = 0; i < nr_elems; i++) {
> > +               name = dirty_path[i];
> > +               len = strlen(name);
> > +               inode_lock_nested(parent->d_inode, I_MUTEX_PARENT);
> > +               child = lookup_one_len(name, parent, len);
> > +               if (IS_ERR(child)) {
> > +                       err = PTR_ERR(child);
> > +                       goto out_unlock;
> > +               }
> > +
> > +               if (!child->d_inode) {
> > +                       unsigned short ftype;
> > +
> > +                       ftype = (i == (nr_elems - 1)) ? S_IFREG : S_IFDIR;
> > +                       child = ovl_create_real(parent->d_inode, child,
> > +                                               OVL_CATTR(ftype | 0));
> > +                       if (IS_ERR(child)) {
> > +                               err = PTR_ERR(child);
> > +                               goto out_unlock;
> > +                       }
> > +               }
> > +
> > +               inode_unlock(parent->d_inode);
> > +               dput(parent);
> > +               parent = child;
> > +               child = NULL;
> > +       }
> > +
> > +       dput(parent);
> > +       return err;
> > +
> > +out_unlock:
> > +       inode_unlock(parent->d_inode);
> > +       dput(parent);
> > +       return err;
> > +}
> > +
> 
> I think a helper ovl_test_create() along the lines of the helper found on
> my ovl-features branch could make this code a lot easier to follow.
> Note that the helper in that branch in not ready to be cherry-picked
> as is - it needs changes, so take it or leave it.

Hi Amir,

For now, I will like to stick with it. You can change it down then line
once ovl_test_create() is ready to be merged.

Vivek

