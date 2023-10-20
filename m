Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C7F2C0032E
	for <linux-unionfs@archiver.kernel.org>; Fri, 20 Oct 2023 20:33:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbjJTUdd (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 20 Oct 2023 16:33:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbjJTUdc (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 20 Oct 2023 16:33:32 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13A131BF;
        Fri, 20 Oct 2023 13:33:31 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id AC1A01F38A;
        Fri, 20 Oct 2023 20:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1697834009; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dY1vhA6P6JzRx3YbrfIEsmGo76RorKoQJ5wlvxO75No=;
        b=F7Nm2U8Ibap+vdS26+w34Dd0dxxDt8ucKU8Q+zhoTIlv/liNtGfD6fvZktvII+ooyUOXYS
        +puWK3unmqLzbo4EbMxJoAAWzwidwgzWwXeGY7OSb1gpW3veZxHLJgrGc7rUgy7ijsvsGw
        pJUnMhZ5ZXLH8huhUjo++aaWWbsCoqQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1697834009;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dY1vhA6P6JzRx3YbrfIEsmGo76RorKoQJ5wlvxO75No=;
        b=N1QJk1kIeCE+KTMfoJeoF9xKs727zJEtZGX6RqdNWv4g+4z05bXyHzraaSUI2KID7oKLJb
        uGxo99uN8nkcWuBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 85AB313584;
        Fri, 20 Oct 2023 20:33:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id BuvnHhnkMmUCcgAAMHmgww
        (envelope-from <ddiss@suse.de>); Fri, 20 Oct 2023 20:33:29 +0000
Date:   Fri, 20 Oct 2023 22:33:27 +0200
From:   David Disseldorp <ddiss@suse.de>
To:     Paul Moore <paul@paul-moore.com>
Cc:     Stephen Smalley <stephen.smalley.work@gmail.com>,
        selinux@vger.kernel.org, linux-unionfs@vger.kernel.org
Subject: Re: [PATCH] RFC: selinux: don't filter copy-up xattrs while
 uninitialized
Message-ID: <20231020223327.09a6a12b@echidna.fritz.box>
In-Reply-To: <CAHC9VhTLjcQXNoc8L3Uw=TRRghLuA_TnQbRkGtwnCu4kxVXE0g@mail.gmail.com>
References: <20231018100815.26278-1-ddiss@suse.de>
        <CAEjxPJ6o8T=K+FHEHdWxn1PQN=Ew+KjooXL=coS0gx4YLuEFhw@mail.gmail.com>
        <CAHC9VhTLjcQXNoc8L3Uw=TRRghLuA_TnQbRkGtwnCu4kxVXE0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Authentication-Results: smtp-out2.suse.de;
        none
X-Spamd-Result: default: False [-7.10 / 50.00];
         ARC_NA(0.00)[];
         RCVD_VIA_SMTP_AUTH(0.00)[];
         FROM_HAS_DN(0.00)[];
         RCPT_COUNT_THREE(0.00)[4];
         TO_DN_SOME(0.00)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         TAGGED_RCPT(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         NEURAL_HAM_LONG(-3.00)[-1.000];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
         NEURAL_HAM_SHORT(-1.00)[-1.000];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         RCVD_COUNT_TWO(0.00)[2];
         RCVD_TLS_ALL(0.00)[];
         BAYES_HAM(-3.00)[100.00%];
         FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org]
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi Paul and Stephen,

On Fri, 20 Oct 2023 11:55:31 -0400, Paul Moore wrote:

> On Fri, Oct 20, 2023 at 8:21=E2=80=AFAM Stephen Smalley
> <stephen.smalley.work@gmail.com> wrote:
> > On Wed, Oct 18, 2023 at 6:08=E2=80=AFAM David Disseldorp <ddiss@suse.de=
> wrote: =20
> > >
> > > Extended attribute copy-up functionality added via 19472b69d639d
> > > ("selinux: Implementation for inode_copy_up_xattr() hook") sees
> > > "security.selinux" contexts dropped, instead relying on contexts
> > > applied via the inode_copy_up() hook.
> > >
> > > When copy-up takes place during early boot, prior to selinux
> > > initialization / policy load, the context stripping can be unwanted
> > > and unexpected. Make filtering dependent on selinux_initialized().
> > >
> > > RFC: This changes user behaviour so is likely unacceptable. Still,
> > > I'd be interested in hearing other suggestions for how this could be
> > > addressed. =20
> >
> > IMHO, this is fixing a bug, only affects early userspace (pre policy
> > load), and is likely acceptable.
> > But Paul will make the final call. We can't introduce and use a new
> > policy capability here because this is before policy has been loaded. =
=20
>=20
> I agree with Stephen, this is a bug fix so I wouldn't worry too much
> about user visible behavior.  For better or worse, the
> SELinux-enabled-but-no-policy-loaded case has always been a bit
> awkward and has required multiple patches over the years to correct
> unwanted behaviors.

Understood.

> I'm open to comments on this, but I don't believe this is something we
> want to see backported to the stable kernels, and considering we are
> currently at v6.6-rc6, this isn't really a candidate for the upcoming
> merge window.  This means we have a few more weeks to comment, test,
> etc. and one of the things I would like to see is a better description
> of before-and-after labeling in the commit description.  This helps
> people who trip over this change, identify what changed, and helps
> them resolve the problem on their systems.
>=20
> Does that sound good?

That sounds good to me. I'll rework the commit description (and comment
above this change), do some further testing and then submit a v2.

Thanks for your feedback,
David
