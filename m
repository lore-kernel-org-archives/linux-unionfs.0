From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v3 00/23] Overlayfs inodes index
Date: Wed, 14 Jun 2017 10:48:29 +0300
Message-ID: <CAOQ4uxh29R0KQPOeUE-AMJ7vEq80Jp-FHAL-28836U5BQTzgdw@mail.gmail.com>
References: <1497425202-16270-1-git-send-email-amir73il@gmail.com> <CAJfpegsjdep+s8WsL30M0rQU7=in_JyX1Bka2=3ELxgk=S3rZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:35653 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750757AbdFNHsb (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 14 Jun 2017 03:48:31 -0400
In-Reply-To: <CAJfpegsjdep+s8WsL30M0rQU7=in_JyX1Bka2=3ELxgk=S3rZA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Wed, Jun 14, 2017 at 10:30 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Wed, Jun 14, 2017 at 9:26 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>> Miklos,
>>
>> I've made all the changes we discussed on v2 review and now all
>> upper/lower hardlinks are consistent. Note that I chose to invalidate
>> lower indexed dentries instead of updating all aliases on first copy up
>> (patch 21). That seemed simpler to me. Please let me know if you see any
>> culprit with that approach.
>
> If the alias is open, it won't receive the st_ino updates through
> fstat(2) since it will still have the ref to the old dentry/old inode.
> So it's more correct to update the aliases, but I guess it's also more
> complex.
>

fstat(2) and st_ino are not a problem, because st_ino of lower is returned
both before and after link up. The issue is with other attributes like mtime.
However, if the alias is open, then read(2) will read the lower content, so you
may as well say that returning the lower mtime is a feature...

My main concern for indexed lower inconsistency was that ovl_inode_real()
may be upper, while ovl_dentry_real() is lower, especially when checking
overlay object access permissions.
The only places I found where this inconsistency might be exposed are
ovl_get_acl() and ovl_permission() and both those cases are relevant for
lookup and not for the "open alias" case. Right?

Amir.
