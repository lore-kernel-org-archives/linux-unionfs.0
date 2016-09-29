From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: Re: [PATCH v6 05/16] sockfs: getxattr: Fail with -EOPNOTSUPP for
 invalid attribute names
Date: Thu, 29 Sep 2016 22:35:30 +0200
Message-ID: <CAHc6FU4U2vqq2ZQ6BGxwmqTx9GtJgRs3d5QGnwJqkifd__JJqw@mail.gmail.com>
References: <1475164125-28635-1-git-send-email-agruenba@redhat.com>
 <1475164125-28635-6-git-send-email-agruenba@redhat.com> <20160929202424.GA9499@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-ua0-f175.google.com ([209.85.217.175]:35483 "EHLO
        mail-ua0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755499AbcI2Ufc (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 29 Sep 2016 16:35:32 -0400
Received: by mail-ua0-f175.google.com with SMTP id q42so76751273uaq.2
        for <linux-unionfs@vger.kernel.org>; Thu, 29 Sep 2016 13:35:31 -0700 (PDT)
In-Reply-To: <20160929202424.GA9499@infradead.org>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Tyler Hicks <tyhicks@canonical.com>, ecryptfs@vger.kernel.org, linux-unionfs@vger.kernel.org, David Howells <dhowells@redhat.com>, Serge Hallyn <serge@hallyn.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, linux-ima-devel@lists.sourceforge.net, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, Casey Schaufler <casey@schaufler-ca.com>, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>

On Thu, Sep 29, 2016 at 10:24 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Thu, Sep 29, 2016 at 05:48:34PM +0200, Andreas Gruenbacher wrote:
>> The standard return value for unsupported attribute names is
>> -EOPNOTSUPP, as opposed to undefined but supported attributes
>> (-ENODATA).
>>
>> Also, fail for attribute names like "system.sockprotonameXXX" and
>> simplify the code a bit.
>
> The only sensible thing to do with this xattr abuse is to remove it
> entirely..

It's quite weird, indeed. Does it have users though?

Thanks,
Andreas
