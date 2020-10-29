Return-Path: <SRS0=8QKN=EE=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BADBAC2D0A3
	for <linux-unionfs@archiver.kernel.org>; Thu, 29 Oct 2020 16:31:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A3BB20825
	for <linux-unionfs@archiver.kernel.org>; Thu, 29 Oct 2020 16:31:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725965AbgJ2Qbq (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 29 Oct 2020 12:31:46 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:35706 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726868AbgJ2Qay (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 29 Oct 2020 12:30:54 -0400
X-Greylist: delayed 2551 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Oct 2020 12:30:54 EDT
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out02.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1kYA9W-008Etr-HE; Thu, 29 Oct 2020 09:47:50 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1kYA9V-00AHk1-Ei; Thu, 29 Oct 2020 09:47:50 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
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
        =?utf-8?Q?St=C3=A9phane?= Graber <stgraber@ubuntu.com>,
        Aleksa Sarai <cyphar@cyphar.com>,
        Lennart Poettering <lennart@poettering.net>,
        smbarber@chromium.org, Phil Estes <estesp@gmail.com>,
        Serge Hallyn <serge@hallyn.com>,
        Kees Cook <keescook@chromium.org>,
        Todd Kjos <tkjos@google.com>, Jonathan Corbet <corbet@lwn.net>,
        containers@lists.linux-foundation.org,
        linux-security-module@vger.kernel.org, linux-api@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-unionfs@vger.kernel.org,
        linux-audit@redhat.com, linux-integrity@vger.kernel.org,
        selinux@vger.kernel.org
References: <20201029003252.2128653-1-christian.brauner@ubuntu.com>
Date:   Thu, 29 Oct 2020 10:47:49 -0500
In-Reply-To: <20201029003252.2128653-1-christian.brauner@ubuntu.com>
        (Christian Brauner's message of "Thu, 29 Oct 2020 01:32:18 +0100")
Message-ID: <87pn51ghju.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1kYA9V-00AHk1-Ei;;;mid=<87pn51ghju.fsf@x220.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/KO2990XPv4odhdV8LRkhzi7akeV9MiV4=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH 00/34] fs: idmapped mounts
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Christian Brauner <christian.brauner@ubuntu.com> writes:

> Hey everyone,
>
> I vanished for a little while to focus on this work here so sorry for
> not being available by mail for a while.
>
> Since quite a long time we have issues with sharing mounts between
> multiple unprivileged containers with different id mappings, sharing a
> rootfs between multiple containers with different id mappings, and also
> sharing regular directories and filesystems between users with different
> uids and gids. The latter use-cases have become even more important with
> the availability and adoption of systemd-homed (cf. [1]) to implement
> portable home directories.

Can you walk us through the motivating use case?

As of this year's LPC I had the distinct impression that the primary use
case for such a feature was due to the RLIMIT_NPROC problem where two
containers with the same users still wanted different uid mappings to
the disk because the users were conflicting with each other because of
the per user rlimits.

Fixing rlimits is straight forward to implement, and easier to manage
for implementations and administrators.



Reading up on systemd-homed it appears to be a way to have encrypted
home directories.  Those home directories can either be encrypted at the
fs or at the block level.  Those home directories appear to have the
goal of being luggable between systems.  If the systems in question
don't have common administration of uids and gids after lugging your
encrypted home directory to another system chowning the files is
required.

Is that the use case you are looking at removing the need for
systemd-homed to avoid chowning after lugging encrypted home directories
from one system to another?  Why would it be desirable to avoid the
chown?


If the goal is to solve fragmented administration of uid assignment I
suggest that it might be better to solve the administration problem so
that all of the uids of interest get assigned the same way on all of the
systems of interest.  To the extent it is possible to solve the uid
assignment problem that would seem to have fewer long term
administrative problems.

Eric
