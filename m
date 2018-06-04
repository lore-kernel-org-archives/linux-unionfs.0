From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 04/39] vfs: add path_open()
Date: Mon, 4 Jun 2018 01:46:09 -0700
Message-ID: <20180604084609.GC11333@infradead.org>
References: <20180529144339.16538-1-mszeredi@redhat.com>
 <20180529144339.16538-5-mszeredi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180529144339.16538-5-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

> +EXPORT_SYMBOL(path_open);

EXPORT_SYMBOL_GPL, please.
