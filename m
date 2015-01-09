From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH RFC resend] ovl: discard independent cursor in readdir()
Date: Fri, 9 Jan 2015 15:11:20 +0100
Message-ID: <CAJfpegsD6ss6wdT8bJjtUWUyWt8r5M8ARN6zmvD7bNOOqjxHaw@mail.gmail.com>
References: <548901BA.3050401@huawei.com>
	<54AF322C.8080601@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qc0-f175.google.com ([209.85.216.175]:48990 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754783AbbAIOLW (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Fri, 9 Jan 2015 09:11:22 -0500
Received: by mail-qc0-f175.google.com with SMTP id p6so8870939qcv.6
        for <linux-unionfs@vger.kernel.org>; Fri, 09 Jan 2015 06:11:20 -0800 (PST)
In-Reply-To: <54AF322C.8080601@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: hujianyang <hujianyang@huawei.com>
Cc: linux-unionfs@vger.kernel.org

On Fri, Jan 9, 2015 at 2:43 AM, hujianyang <hujianyang@huawei.com> wrote:

> How do you feel about this cleanup?

Pushed a modified version.

Thanks,
Miklos
