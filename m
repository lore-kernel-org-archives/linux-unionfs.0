Return-Path: <SRS0=dIwb=EI=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D927DC388F2
	for <linux-unionfs@archiver.kernel.org>; Mon,  2 Nov 2020 13:25:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9550722268
	for <linux-unionfs@archiver.kernel.org>; Mon,  2 Nov 2020 13:25:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbgKBNZ0 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 2 Nov 2020 08:25:26 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48665 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726060AbgKBNZZ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 2 Nov 2020 08:25:25 -0500
Received: from ip5f5af0a0.dynamic.kabel-deutschland.de ([95.90.240.160] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1kZZpp-0007CP-3c; Mon, 02 Nov 2020 13:25:21 +0000
Date:   Mon, 2 Nov 2020 14:25:16 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
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
Message-ID: <20201102132516.rvm2muir7pwahrpq@wittgenstein>
References: <20201029003252.2128653-1-christian.brauner@ubuntu.com>
 <20201029003252.2128653-7-christian.brauner@ubuntu.com>
 <20201101144632.GD23378@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201101144632.GD23378@infradead.org>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun, Nov 01, 2020 at 02:46:32PM +0000, Christoph Hellwig wrote:
> > +static inline kuid_t kuid_into_mnt(struct user_namespace *to, kuid_t kuid)
> > +{
> > +#ifdef CONFIG_IDMAP_MOUNTS
> > +	return make_kuid(to, __kuid_val(kuid));
> > +#else
> > +	return kuid;
> > +#endif
> > +}
> > +
> > +static inline kgid_t kgid_into_mnt(struct user_namespace *to, kgid_t kgid)
> > +{
> > +#ifdef CONFIG_IDMAP_MOUNTS
> > +	return make_kgid(to, __kgid_val(kgid));
> > +#else
> > +	return kgid;
> > +#endif
> 
> If you want to keep the config option please at least have on
> #ifdef/#else/#endif instead of this mess.

Understood.
