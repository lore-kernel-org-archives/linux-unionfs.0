From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: Re: [RFC 4/8] evm: Turn evm_update_evmxattr into void function
Date: Wed, 4 May 2016 13:20:48 +0200
Message-ID: <CAHc6FU5JV2gCRdjVQV3jfwGT+tyU9qBV3=Z9LRDnxyj-dSXgxQ@mail.gmail.com>
References: <1462229118-13123-1-git-send-email-agruenba@redhat.com>
	<1462229118-13123-5-git-send-email-agruenba@redhat.com>
	<alpine.LRH.2.20.1605041722290.13639@namei.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f179.google.com ([209.85.161.179]:36117 "EHLO
	mail-yw0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473AbcEDLUt (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Wed, 4 May 2016 07:20:49 -0400
Received: by mail-yw0-f179.google.com with SMTP id o66so82037657ywc.3
        for <linux-unionfs@vger.kernel.org>; Wed, 04 May 2016 04:20:48 -0700 (PDT)
In-Reply-To: <alpine.LRH.2.20.1605041722290.13639@namei.org>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: James Morris <jmorris@namei.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Tyler Hicks <tyhicks@canonical.com>, ecryptfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fuse-devel@lists.sourceforge.net, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-ima-devel@lists.sourceforge.net, LSM <linux-security-module@vger.kernel.org>, David Howells <dhowells@redhat.com>, Serge Hallyn <serge.hallyn@canonical.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, Casey Schaufler <casey@schaufler-ca.com>

On Wed, May 4, 2016 at 9:23 AM, James Morris <jmorris@namei.org> wrote:
> On Tue, 3 May 2016, Andreas Gruenbacher wrote:
>
>> The return value of evm_update_evmxattr is never used.
>
> Perhaps it should be used, otherwise there are potential silent failure
> paths in the EVM code.

Yes, perhaps. That's not the only place in EVM / IMA where such
failures are silently
ignored though; the code seems to need some work.

Thanks,
Andreas
