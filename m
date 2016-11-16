From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 1/2] ovl: use kernel facility for copying attributes
Date: Wed, 16 Nov 2016 10:23:11 +0100
Message-ID: <CAJfpegsHvz2G8n_Nw8v2aoophDQCBvcB7v1mkWonifsUqJ7HhA@mail.gmail.com>
References: <1479228894-10533-1-git-send-email-quorum.laval@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:33722 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752720AbcKPJXN (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 16 Nov 2016 04:23:13 -0500
Received: by mail-oi0-f67.google.com with SMTP id f201so2132808oib.0
        for <linux-unionfs@vger.kernel.org>; Wed, 16 Nov 2016 01:23:12 -0800 (PST)
In-Reply-To: <1479228894-10533-1-git-send-email-quorum.laval@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Quorum Laval <quorum.laval@gmail.com>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-kernel@vger.kernel.org

On Tue, Nov 15, 2016 at 5:54 PM, Quorum Laval <quorum.laval@gmail.com> wrote:
> Replace ovl_copyattr() by fsstack_copy_attr_all() and drop the definition of
> the former.

This isn't trivially correct, fsstack_copy_attr_all() copies more than
ovl_copyattr().   We need a better explanation for why it is correct
to copy all the other attributes as well.

Thanks,
Miklos
