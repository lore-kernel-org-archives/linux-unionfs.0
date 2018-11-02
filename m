Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46464 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726049AbeKCAnn (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 2 Nov 2018 20:43:43 -0400
Date: Fri, 2 Nov 2018 16:34:53 +0100
From: Cyril Hrubis <chrubis@suse.cz>
Subject: Re: [PATCH v3 1/6] syscalls/readahead01: Convert to newlib
Message-ID: <20181102153453.GB30704@rei.lan>
References: <20181010233441.5337-1-amir73il@gmail.com>
 <20181010233441.5337-2-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181010233441.5337-2-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: ltp@lists.linux.it, Jan Stancek <jstancek@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Hi!
Pushed with minor changes:

* close() -> SAFE_CLOSE()

* Changed the check_* functions to void since we do not use the returned
  value

* Removed .needs_root = 1 since the test isn't doing anything priviledged

Thanks.

-- 
Cyril Hrubis
chrubis@suse.cz
