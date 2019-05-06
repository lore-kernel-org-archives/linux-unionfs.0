MIME-Version: 1.0
Date: Mon, 6 May 2019 07:57:08 -0400
References: <20190227113211.28006-1-amir73il@gmail.com>
In-Reply-To: <20190227113211.28006-1-amir73il@gmail.com>
Message-ID: <CAJfpegsD8DWW4d8yFxbL57cUHehE8AoiDU-OyB-FCMZ6+3nONA@mail.gmail.com>
Subject: Re: [PATCH v2] ovl: support stacked SEEK_HOLE/SEEK_DATA
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>
Cc: Eddie Horng <eddiehorng.tw@gmail.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Feb 27, 2019 at 7:32 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> Overlay file f_pos is the master copy that is preserved
> through copy up and modified on read/write, but only real
> fs knows how to SEEK_HOLE/SEEK_DATA and real fs may impose
> limitations that are more strict than ->s_maxbytes for specific
> files, so we use the real file to perform seeks.
>
> We do not call real fs for SEEK_CUR:0 query and for SEEK_SET:0
> requests.
>
> Fixes: d1d04ef8572b ("ovl: stack file ops")
> Reported-by: Eddie Horng <eddiehorng.tw@gmail.com>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>

Thanks, applied.

Miklos
