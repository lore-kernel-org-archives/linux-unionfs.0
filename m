From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [RFC][PATCH] linux/uuid.h: hoist uuid_is_null() helper from libnvdimm
Date: Tue, 2 May 2017 13:57:23 -0700
Message-ID: <CAPcyv4jnAxjKYvZs+XFKZ-z0VN4gT9rHMEZbFjozPBukRVGbOQ@mail.gmail.com>
References: <1493756363-5113-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:36089 "EHLO
        mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751544AbdEBU5Y (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 2 May 2017 16:57:24 -0400
Received: by mail-oi0-f48.google.com with SMTP id h4so5461949oib.3
        for <linux-unionfs@vger.kernel.org>; Tue, 02 May 2017 13:57:24 -0700 (PDT)
In-Reply-To: <1493756363-5113-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Miklos Szeredi <miklos@szeredi.hu>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Richard Weinberger <richard@nod.at>, "Darrick J . Wong" <darrick.wong@oracle.com>, Mark Fasheh <mfasheh@versity.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-xfs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, David Howells <dhowells@redhat.com>

On Tue, May 2, 2017 at 1:19 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> We need a helper for VFS to check if struct super_block field s_uuid
> was filled by the filesystem, before consumers can use it.
>
> The libnvdimm code already has a private helper to check if uuid is null
> and the helper name is not using a private namespace prefix, which
> prevents us from using the same helper name as a common function.
>
> Hoist the libnvdimm helper as an inline helper to linux/uuid.h.
>
> Suggested-by: Christoph Hellwig <hch@lst.de>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: David Howells <dhowells@redhat.com>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>

Acked-by: Dan Williams <dan.j.williams@intel.com>
