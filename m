From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 2/2] ovl: use kernel facility for updating access time
Date: Wed, 16 Nov 2016 10:25:16 +0100
Message-ID: <CAJfpegvCKipVi2Ar_amt+rrL2YL47Aj_+VDq8pjhiDvqWZihQQ@mail.gmail.com>
References: <1479228894-10533-1-git-send-email-quorum.laval@gmail.com> <1479228894-10533-2-git-send-email-quorum.laval@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:33985 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752720AbcKPJZS (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 16 Nov 2016 04:25:18 -0500
Received: by mail-oi0-f68.google.com with SMTP id z62so5907922oiz.1
        for <linux-unionfs@vger.kernel.org>; Wed, 16 Nov 2016 01:25:17 -0800 (PST)
In-Reply-To: <1479228894-10533-2-git-send-email-quorum.laval@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Quorum Laval <quorum.laval@gmail.com>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-kernel@vger.kernel.org

On Tue, Nov 15, 2016 at 5:54 PM, Quorum Laval <quorum.laval@gmail.com> wrote:
> Use fsstack_copy_attr_atime() instead of direct assignement.

This one's correct, but what's the point?

Thanks,
Miklos
