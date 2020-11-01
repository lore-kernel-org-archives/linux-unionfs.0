Return-Path: <SRS0=JeHB=EH=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 562DDC5517A
	for <linux-unionfs@archiver.kernel.org>; Sun,  1 Nov 2020 14:46:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2818A2224F
	for <linux-unionfs@archiver.kernel.org>; Sun,  1 Nov 2020 14:46:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="q3mdWyij"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbgKAOqh (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 1 Nov 2020 09:46:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726458AbgKAOqh (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 1 Nov 2020 09:46:37 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C13A2C0617A6;
        Sun,  1 Nov 2020 06:46:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ecTJHGTyUmsna16Nipqp/caudodMDR0L+6mieeHEVz0=; b=q3mdWyijCuChf1I+Nl89lM1Hi/
        8QLngbL3lC1CUTaJQgH/l7Pdwl+4KIblTZJvnZtejunYcHjL3djEY8TdKoHYN6/27P2iKnQHDu2uG
        AI+fb51LwOCrwtw+Iy/+FwtHDgH+DA+lwLK/OADJQZk/zyf9D4PiZkzR5iAl9/mmQWn9MpsoF4VDI
        DyFp3zwImLfoJmCnI0vntmirHu+SW+YoTdKfXYoiDF1SJvYaga+iHBvq+ktMmoQOciLo90leiyiZA
        J0eTamb8RlQl3U+yihGs05QJ0ifcE1hZ10yx/Qe6q7/ykqutkrivTlB/L/LUPhzohONGtzltfUQ5R
        4Qb+/11w==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kZEcq-0006a4-4R; Sun, 01 Nov 2020 14:46:32 +0000
Date:   Sun, 1 Nov 2020 14:46:32 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org,
        John Johansen <john.johansen@canonical.com>,
        James Morris <jmorris@namei.org>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Geoffrey Thomas <geofft@ldpreload.com>,
        Mrunal Patel <mpatel@redhat.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Andy Lutomirski <luto@kernel.org>,
        Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Theodore Tso <tytso@mit.edu>, Alban Crequy <alban@kinvolk.io>,
        Tycho Andersen <tycho@tycho.ws>,
        David Howells <dhowells@redhat.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jann Horn <jannh@google.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        St??phane Graber <stgraber@ubuntu.com>,
        Aleksa Sarai <cyphar@cyphar.com>,
        Lennart Poettering <lennart@poettering.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>, smbarber@chromium.org,
        Phil Estes <estesp@gmail.com>, Serge Hallyn <serge@hallyn.com>,
        Kees Cook <keescook@chromium.org>,
        Todd Kjos <tkjos@google.com>, Jonathan Corbet <corbet@lwn.net>,
        containers@lists.linux-foundation.org,
        linux-security-module@vger.kernel.org, linux-api@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-unionfs@vger.kernel.org,
        linux-audit@redhat.com, linux-integrity@vger.kernel.org,
        selinux@vger.kernel.org
Subject: Re: [PATCH 06/34] fs: add id translation helpers
Message-ID: <20201101144632.GD23378@infradead.org>
References: <20201029003252.2128653-1-christian.brauner@ubuntu.com>
 <20201029003252.2128653-7-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201029003252.2128653-7-christian.brauner@ubuntu.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

> +static inline kuid_t kuid_into_mnt(struct user_namespace *to, kuid_t kuid)
> +{
> +#ifdef CONFIG_IDMAP_MOUNTS
> +	return make_kuid(to, __kuid_val(kuid));
> +#else
> +	return kuid;
> +#endif
> +}
> +
> +static inline kgid_t kgid_into_mnt(struct user_namespace *to, kgid_t kgid)
> +{
> +#ifdef CONFIG_IDMAP_MOUNTS
> +	return make_kgid(to, __kgid_val(kgid));
> +#else
> +	return kgid;
> +#endif

If you want to keep the config option please at least have on
#ifdef/#else/#endif instead of this mess.
