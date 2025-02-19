import Buffer "mo:base/Buffer";
import D "mo:base/Debug";
import ExperimentalCycles "mo:base/ExperimentalCycles";

import Principal "mo:base/Principal";
// import Time "mo:base/Time";

// import CertifiedData "mo:base/CertifiedData";
import CertTree "mo:cert/CertTree";

import ICRC1 "mo:icrc1-mo/ICRC1";
import ICRC2 "mo:icrc2-mo/ICRC2";
import ICRC3 "mo:icrc3-mo/";
import ICRC4 "mo:icrc4-mo/ICRC4";

shared ({ caller = _owner }) actor class Token  (args: ?{
    icrc1 : ?ICRC1.InitArgs;
    icrc2 : ?ICRC2.InitArgs;
    icrc3 : ICRC3.InitArgs; //already typed nullable
    icrc4 : ?ICRC4.InitArgs;
  }
) = this{

    let default_icrc1_args : ICRC1.InitArgs = {
      name = ?"DCitizen Token";
      symbol = ?"DCT";
      logo = ?"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAYAAABXAvmHAAAACXBIWXMAAA7EAAAOxAGVKw4bAAAFkmlUWHRYTUw6Y29tLmFkb2JlLnhtcAAAAAAAPD94cGFja2V0IGJlZ2luPSfvu78nIGlkPSdXNU0wTXBDZWhpSHpyZVN6TlRjemtjOWQnPz4KPHg6eG1wbWV0YSB4bWxuczp4PSdhZG9iZTpuczptZXRhLyc+CjxyZGY6UkRGIHhtbG5zOnJkZj0naHR0cDovL3d3dy53My5vcmcvMTk5OS8wMi8yMi1yZGYtc3ludGF4LW5zIyc+CgogPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9JycKICB4bWxuczpBdHRyaWI9J2h0dHA6Ly9ucy5hdHRyaWJ1dGlvbi5jb20vYWRzLzEuMC8nPgogIDxBdHRyaWI6QWRzPgogICA8cmRmOlNlcT4KICAgIDxyZGY6bGkgcmRmOnBhcnNlVHlwZT0nUmVzb3VyY2UnPgogICAgIDxBdHRyaWI6Q3JlYXRlZD4yMDI1LTAyLTE4PC9BdHRyaWI6Q3JlYXRlZD4KICAgICA8QXR0cmliOkV4dElkPmFkZmY4MWRjLWViZTgtNDA2My04OWM0LTRlMTcyMDMxZTU1NzwvQXR0cmliOkV4dElkPgogICAgIDxBdHRyaWI6RmJJZD41MjUyNjU5MTQxNzk1ODA8L0F0dHJpYjpGYklkPgogICAgIDxBdHRyaWI6VG91Y2hUeXBlPjI8L0F0dHJpYjpUb3VjaFR5cGU+CiAgICA8L3JkZjpsaT4KICAgPC9yZGY6U2VxPgogIDwvQXR0cmliOkFkcz4KIDwvcmRmOkRlc2NyaXB0aW9uPgoKIDxyZGY6RGVzY3JpcHRpb24gcmRmOmFib3V0PScnCiAgeG1sbnM6Q29udGFpbnNBaUdlbmVyYXRlZENvbnRlbnQ9J2h0dHBzOi8vY2FudmEuY29tL2V4cG9ydCc+CiAgPENvbnRhaW5zQWlHZW5lcmF0ZWRDb250ZW50OkNvbnRhaW5zQWlHZW5lcmF0ZWRDb250ZW50PlllczwvQ29udGFpbnNBaUdlbmVyYXRlZENvbnRlbnQ6Q29udGFpbnNBaUdlbmVyYXRlZENvbnRlbnQ+CiA8L3JkZjpEZXNjcmlwdGlvbj4KCiA8cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0nJwogIHhtbG5zOmRjPSdodHRwOi8vcHVybC5vcmcvZGMvZWxlbWVudHMvMS4xLyc+CiAgPGRjOnRpdGxlPgogICA8cmRmOkFsdD4KICAgIDxyZGY6bGkgeG1sOmxhbmc9J3gtZGVmYXVsdCc+RENUIC0gMTwvcmRmOmxpPgogICA8L3JkZjpBbHQ+CiAgPC9kYzp0aXRsZT4KIDwvcmRmOkRlc2NyaXB0aW9uPgoKIDxyZGY6RGVzY3JpcHRpb24gcmRmOmFib3V0PScnCiAgeG1sbnM6cGRmPSdodHRwOi8vbnMuYWRvYmUuY29tL3BkZi8xLjMvJz4KICA8cGRmOkF1dGhvcj5SRVIgREFPPC9wZGY6QXV0aG9yPgogPC9yZGY6RGVzY3JpcHRpb24+CgogPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9JycKICB4bWxuczp4bXA9J2h0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8nPgogIDx4bXA6Q3JlYXRvclRvb2w+Q2FudmEgKFJlbmRlcmVyKSBkb2M9REFHZmNyYng3TzggdXNlcj1VQUZfZDM0S3NtSSBicmFuZD1CQUdLczhhcXpGZyB0ZW1wbGF0ZT08L3htcDpDcmVhdG9yVG9vbD4KIDwvcmRmOkRlc2NyaXB0aW9uPgo8L3JkZjpSREY+CjwveDp4bXBtZXRhPgo8P3hwYWNrZXQgZW5kPSdyJz8+0dXL2AAAFVZJREFUeJy1mnmMXdd93z/n3PXt2+xDUlxmuEmkJFIbtZCSraio3SYN2rpxEMcq3Boq0DQqWii20yqx49qIixaFE8BKUseR6zZFXbR1Yyd1XUjWYtGSSJEccRP34XDWN2+/7727ntM/3syItOVGqZMDHNx7557B/X5/9/v7/s459wl+ynbkyA6OPDK17Tf+xc/cH/vB/rBV2xt6zem43xtTcZQFkKblmW562coWLjnFobPSdWc+//nvvv7971+8/NKrV3+q54v/33989jNPjD780Ja//uD+4lPe/JV7mxfflv2VeTQKNEQJ6LUHKA2WCVIIkJL00CTF6TtUZmLbsdffbj/38mvX/vRz/+p7y3/lBI48tJ0jj+4Y/ZfPHPlM8/K5jzXOHi8FrRo9X9HqCgwbrJSm3RLYLhQKmq6niWKDbC5hZdGgWNKEPcg5BtmMwC1WKO850Chs3/P8b33pxS++9OrllZdeuvKXT+DI4e3WC9/94KfrZ7r/pHHuRCX0OtQ6GmVo0jlN4GtqVU2nqen3NPWaBK1xXEkcazSK8UmwXYPxCUhlBI2axBSSXEpSHs5T2nNX9cSC++8++4XvfemVV6/Ff2kEXvjOP9h3//7ic6vHf3Cov7osBsATNIqVRUWzrlhdEYDEdgSmBVKCFjA6YhCGmlZTg4aupwkDjWUrtk1DZdQgkwWvbTOSNylNjunKXQ+88tqp2lOPf+ir534qAocf3soL3/2Hf6tz6eJXaydfL/tBwnwjojIUszCXcOakgWkLKkMG+awgiqHRXBM/AwL7brcZHzGYORszvcPg1ExEFGlyOYPqckyjEZEvCO47bKATiQptRkouwwfurWbGNz352M89/6evvPKTE934ieAf2iqf/dRjn8w3Ln+tdW4mW+9ollohrhvz9ilYWbLIlywefCDHlk02vb5k754USknankZIiRCC0VGHbl8yNGzT9yWNesJDD+VQWrJtW4rSkEO1qjh9UlEcEhRHE2o1iFaWM5bJ39191/T12eutmdm55vsncOThrfzGpx795L5M9Xd6c9esVpCgjIC52YQrFw1MaWHZBkJIDMOgPOxw+mwPw7bYssVl7kaEEBIhJRObUly8HLJ3TxqvB07KQBomM6cD2p5maMim1VJksgYLc5raimZkkybSENZaxtTm9Id3H9g9e3W2fur6XOvHsMr3IvDCtz/28/uLzS/3Fm6YK72ExOxz8pSi2bDYu7vAI4fLPP54hZHRFNXVhHzBoVBKI02TfiiRhoE0DIolh0LRxU2ZLK6A0gaWY9HpQTptct99Jfr+gKhhGhSKDmFg8+YPFL1exHK7y+KFa/bdo/0/ePFbv/yh9/UG/s+3Pn7nkG78t87FdzKL9Vhg+hx7HVRkMzLsMrnJ5dhbXQzTZN++HFeu+YxOZJicdIkiOH+ui9IghCAMBXNzfcIAVlcTGo2ErhczNZVnYiJFKm1y9kwXpQbjkQLHNRkZS3HhbMT4pKDTi5E9z0jnM0988Ik7vv31/zyzejNe8xbdP7jFfvD23O+tvP5qcbWjhHT7HD+mEcrGsgzyBZtc3kGKHleu+GzfkcO2Dd650KdWDUBDriSZKEMmIzFtBdjEkSIONR1P06zBGz9sIi1JqWQTJYN8ARBaMzzicu/BPC8ngpPHOzzyGCy3u6TOnB5+6P5Dzz3y4G0ffOW12Q2L3XgDRx7cwgvf/thvrh5/86Ne2xeh7HHpoqTvGUxMpogT8APF7l05imUHyzEQQjA/7xNHCZt3wNQuSaliUC5lSKdTuHYG20qRcR3SGRfHlmzZrimUIQih1VTotbdlWQYTmzLce7DAmbMe4xMp2q2EG3MxO3cnVKuaDP0tt9+3N5hdar4yO9u+lcDH/96+yQOj0R92F+dTzTAUzZZifk6w/bYcYxMumaxNpWxz5nwP2zaII7h0qc/YJOzcK8jlU2TTJcZHixTyaXJZl1zWIZc1yWZdclmXcjmLY2WQhkupEjM+qWnWDaIIdu8tsH9fnjePtZib6zEyYuM6BktLIV7bYMv2CK8eib27hvcv1MXzL712vXsLge998+/86/rpUw8vVUPRj0MWFwQqMrjzQIGOp9i7K4vtmtiOwYV3PDqdiOk9gsKQRTE/wsRYgUzaQko5cKC1LqWBlHKjW5ZBNmOTSedodwSFoR5h32T+hk++YBOGislNaXZsS/POhQ5xpKnVFZm0IJEKKwoyP/uR+63P/Zuj390g8Ow/f3Dy4Cb9ld7KsnttMcLNJsxfMzANSTpjsW1LmpNvd/B6GqUEjWbI9O1QKGe4bXKUQs5Z830JQgxI3NwN491zse46klIxhWWkcHMeSQKXL/qMDKfI5y1OzrSo16OBTCTUGzC5SdFpagql1C47l/ujl47e6A4I/NP7fzHXuf63a41IFMd8Th53MAUgBI1GTLUes//OEo5tcOZ0m61TglI5xW0TIziOiRACIcXgKATSkIPrDdBr99fHrB0RgpRrobWL6XgEvuDG9YChUZdS2WbzlhQTE2m2b0tx+bJPoaRQQpHRYSo3OXn26988e9I8cmiTOHRH4anlY33MdEy9YSK05sCBAtI06fUVnY7i+y+uIAzB2CQ4aZPN46PYjolADCYk650BcbF2rm9yObF2Dw1aa4QGlGaonMLzRtg+vUq3A9ev9TBNwfCwTbko6XQUlqmpLhvs3B3RrHscerjw1JFDk1+TRw5NTvu16j4/1KK6GuGHEteWRLHirRMtymWHuw8U2LQli2nAlm2CsZEKrmuueTdgiFsjLgVCGmt9Xf9r10LeMg5DIIRk6+YsSqfYNg2NWkAqbTA0ZNHrJbz1VhtDCFZXBV5H0O7G+PXaPY8e2rRDPvv0Pfd1l5ZEt6+pDCtuXDMxTSgVbVxb8sOjqywvh6yu+kzeJjCMFGMj2UGEBbAuh1t0/67mpfiR6zVJSbGeMwyCIASTYxWKJYFpCqIoIYo1x99qoZUGAYZhsLqqCVRMa2FRPvurB+83VRjtC7ueMGxNry8h0fT7im5f8fjjQySJoNFWBL6mWALTyG/oFyE2ZDFwnTXprOtHiIFU1mSzLigB6LX1mkCihUIISKVMgiDF6KY+87M+YaSwTEHKNZkYd1ipR6g4olwJaNfaJHG834x73dsBqo0YO2OjVYLlCE681ebipR6Oa9FqxmTzGscxGR1J8fzzl5iZaawVIMnUzgIf+YXtlCupNWKwsuLzn56/wOmZGlGk2LWnxEd+cYqpqTznzzf5yu+cBgRKadADYs88czu5bAY15nH9KuzcmaOUL6DimHY7IIwSrs0adDsSM1GEnrdXxn5/BxohpEYaJkLCoUNFdu7KMDmWolQykRLSGYnWDqaUrK4G1Oshcazo9WJefXmJz3/2BL1+AlLQbEV89tff4NgbK5QrLlu35zl3ps4XfvMYS0uDBM3nbfx+TKMeoJQmX7AxTEk2bePYBqYF3U7Miy+ucn0h4PU329iWJlEGUZQQxoo46E0Zzzy5/be8WiMVGxGrtQy9dkgUC0oVm+mpDImWLC2GjExqMqkMxWKKo0errKz4/Pqzd/ILv7SDRiPk7OkG6YzJrj1l/ud/v8rMiRqHPzDJr332Hh77mU0MD6dYXuxRKDocODjEBz44SRQpzp1t8tFf2sGTT06Rdg0QmpXVNj1PYxqSzZsdigWD7VstFhZ8PE8yucUnCWBotGiYOokzWmu6niSTAS8l2X9HipYHL79ao9cXxHFCOiUwDGOg3pu8UQjBI0fGeenFRa5d7YCA61c7ADx4ZGJgs2geeXSCR46MD7Yo0Gj9rnQkAzvVWrO+lyGk4sqVLps3OZw/H9JuBYR+jJ3JEPiK0BeoOMpKnQwSyLEVGnBTkm43IfAV01NZHn6ojEag1bq3v4teSgFa0+8NJoeOM5iZWPbg6HXCjbG+n3DqRI3Fpd6gDqAHNrrWlFYordB6UKziWDM64qC1oNkIiMJkYAhS0qhJUhmFjhWmVtpTSpctR1NdldRXQ175QWtgdVKSL7mApteHbDZZC9qAxKWLbVZrAX/8jcE2yIGDQ6A1B+4d5s0fLvNf/+NFyhWXfM7i6189x8yJGh//xC7GnpgErVFKDcCvJ7LWJIlCxyCExLIgX5Dcd2+ec2c71OshCM3waEy/aaCU6poauSyFKtdXJfmcomlJhsoWlmNQKDhIQ9LtxkS+IIpD0HrDJf/oDy9tRPDIY+McvHdA4KHDY5w4VuWNo8t87tOvb4zZMZXnyGPjaL0uobUbWqPRaK2IY4U0EgI/oUPCwoLPnj0uB+5KcfmqYL4qCQMAhUYumwrjktZ6j2tDrpisLbYd5uYjrl7rMzGRYmLcod3xKY+EJEpz+PAo27bnQA/2eXbtLrJrT3FteqCRQvAr/2wfJ4+PM3OyRhIrtm3P8/DhMUyDDancsa9IHCXs3JVbI6Xo9UOSWNNrK27f5TA05NLvRSwvRnQ8kDJCAIZQGmFeNpUwz6KTv+naEt/rIwyHc+906XZheMRhbMxitRazuAiCiGYr4OCBEgfvqSDXJmYYYiMhtdaDaZGGu++ucPfdlY2/a63XwA+iv317lm23pVEqQSUJSmla7R46ThCGYGnZ58zZAK8dkiQay3VRyieTVcSRRknrjBkpPYPlggqRhJhOluGK5oF700TKoNGMuT7bI46h31N4KY9y0UHoQS3VGqQSYILWCrRA31ShWRvHWoTX3Ucr0Erf1BVBkKCSPlcuCIbKJtmsJI4lEkkUJkSGzZbRFstLMFl2dazE24aKde++2wv/WIQ9EYoY6eaozvdZqcacP9ej29Vs254mjhVtT1EoBlhmFseWGza6kRQ/2tZADxJUbRjAzaCVTgZvQGmWVjpEcZe5a+C4gp1TDpahGRuRjA5L5ldNDN0lldKUh4bUl7+58Bl59GTtsjLcY46liANJ1u3RTyxWqyGJUnS7IdWqz65dGbpNaDckiyt1lBpEcx2ITvSgKzUAphK0Sm6JMmp9zPq4ZG2sot0NsOw2F84IikWDO+/MEASD+3NzIVeXLKQK2DoVI0OltZl5++ip+kX5xtk6r53xnlPCQAeCjNvFSqc2IqeUIpuVlEsGmzalmL2cEAYe84udAUidoNYBJwkqHvizTgYd9e65WieXJO/qPkkI+jGLiw0W5gZ7p61mTL0e0qgHrNZCJicEDc+kXG7RqgkKOckPz3rPvXmmrg2AsbK9eHBP4RMp2U1VWxrbNel1DXbusNh7e4pC3uTMmS7tTkKvp+h1BelCl65nks9Za+uYgRWuL1bWjxua13pAZoP0QDZBkHDpepU4irjyzqAOKKVYWgyolARaJyyuWvR7CZNjHlIr3Gyl/T9+0Hn6+PlWxwA4fq7VffJnt4452ntAKxge82mHI/RaHrYJx97yaLdjAl+BEEQBRIGkUOnj9RJSro1cNyJxK+h1e1yXyiDyCqU0nhdyY6mK3w25dA6SZD3BB5KsLods3myy4pVwxDLZfIQTS61To8//oy+d+WO4aVdCK33irunckznTz1RbmlwuYqmaYfGGh1KD4msYkM4YRJGi34NmHWw7pNPtoTFwbGPgTvrd+c4gV9bBa1Si6PsRK7U2nX6D+lLC1XfEIC+0IlcwCHoD7WutaPSyqKDFjimPlTmti5VC47nv1D568kKncwuBIEy6o8M5a1Mp+UDsa6FlhHQK9DoKFUcIKdi522X7NpdaPSIONXEE1RWNbUMq22VhyUOj6HoatVZdVaIIQ0W7E9JuB1TrHt1+i64XcPm8oLqsNt7U8IjJHbst/EDRaccYTgppO+zYVqW6KBgrCQJS//Zrf7b6reX1HYt1AtVmxMKKf/QDB4cfLaW82zqeQanYxYtHiIMQHcdkswZxAgvzERpNLm8CmlZds3gDIl+jCND06Ucdms0u9ZZHs9UhSnoEYZfaSsTcNZi7qgkDhW0LkmjgVkkUI4Sm00kIIgM7X2a8dIMw0BSsUCfW8BtPf2X+789c7ibruH/MwH/7k1v3PDAtX8rZneFmZBIrgxu1ScJmHR1HIORgimwIDh8uUGtoLrzTRydrlZjBGtm0NbYzWDQmiSb0IVZrOxEMit6OqRRhENPtKVYW/Q39C9vGyVeoZGeplBP6zUhbdq75+iX52Kf+/eypm/H+2Pb6r/3+tXPNjvFk17fDnIywrZjpzQukhsoI20UnA3+f2moxO9vHFDFxFDK9y2VoxEJrhZsCraDbVnQ7in5XY5oghcayYM/eQSUvFzTLSwHbNgsMqVEqwXBTOMUK5cx1xsZi/GakbdOKWj3rEz8K/hYJ3dxOX+1dzKbT1ycrfNgVkaFMzehIm15cIcEhDvq0WwlDFUGzEVEuWuQLBv1uTKlskc1KRoZM4lixf38Gx4aRERPLFKgoYctmE8vSLMyH3LZZsjAf0u4o7HwZ6TiMF+dx3ZB2Nca1jfiV886v/u6fVL+x0vzx737vSWClFbPcCGdSTmp2vCg+XLRCoxdJKqUWWhuQHSf0Q6pLPfq+IpMRdDoxlqnIpQSzcxHlkmR5OSLlQseLcEzIZ6HrRTQaEY6jqa1GXJ8L6ccubmUUETXZM70CxPRrIWnHjF4+Y//Kf3ml/gdnrvv6vbD+xG9k1XbCSiM+dcdE6a0k4YmK28v4vsRyfYaKbcxMDp9h0NCodmm3YzqewuvElMuCKIqJw4RsVrCyHGEamkY9pN2J8DoJy8sx2s7hlIYwpCYtFrhtq4ffTxBdnzhO11camV/+vf+9+o1z88F7gof3+Zn1M39jdM+d28znJka8RyxHiVZoky1JNJLrCxXCJEscgYp8kqCPCkO0St59ggYhDaRtI+0UhuMAEkN3GC3XsOyIoC+wdICltK7W8kdPXlNPffHby2//edje94funaOW+fMHis88tCd5enjIH460xEsc0jmFlBLfN+jHeZpeAWk5xIlEJYPVm5ACnSQIHZCx2pi0cWxFLq8RRkJ7KSFtRbRbqZp9zvzy02+1vvjOShi9H1x/oZ8aTA9b7Bl3R37ujsynS+Xg48MjfsmwNI2ujZWWxImkPCTodgWlMrRbmjCEUgWiSNPrCBARti3x6hpHBBgaaqtOo950/8OfzHS/cH7JX75QfV8f6f/iBG5uH96bGd01bHxo/2bzqXw+vqdcCWUqE+MHBn5iECcCxwGQ+L7CsjQ6UeRSMaFvUF+1VbtjvXliNn7u8mr8Z9851/ur/7HHe7Wpss30kLXjr02n7ndMvd92k722raZMU49KqbMASgkvjsVSGIiLQWCejSJm/tel/usXqsHVy43kz3vE/7P9X7SQpZht1Ok8AAAAAElFTkSuQmCC";
      decimals = 8;
      fee = ?#Fixed(10000);
      minting_account = ?{
        owner = _owner;
        subaccount = null;
      };
      max_supply = null;
      min_burn_amount = ?10000;
      max_memo = ?64;
      advanced_settings = null;
      metadata = null;
      fee_collector = null;
      transaction_window = null;
      permitted_drift = null;
      max_accounts = ?1000000000;
      settle_to_accounts = ?99999000;
    };

    let default_icrc2_args : ICRC2.InitArgs = {
      max_approvals_per_account = ?10000;
      max_allowance = ?#TotalSupply;
      fee = ?#ICRC1;
      advanced_settings = null;
      max_approvals = ?10000000;
      settle_to_approvals = ?9990000;
    };

    let default_icrc3_args : ICRC3.InitArgs = ?{
      maxActiveRecords = 3000;
      settleToRecords = 2000;
      maxRecordsInArchiveInstance = 100000000;
      maxArchivePages = 62500;
      archiveIndexType = #Stable;
      maxRecordsToArchive = 8000;
      archiveCycles = 6_000_000_000_000;
      archiveControllers = null;//??[put cycle ops prinicpal here];
      supportedBlocks = [
        {
          block_type = "1xfer"; 
          url="https://github.com/dfinity/ICRC-1/tree/main/standards/ICRC-3";
        },
        {
          block_type = "2xfer"; 
          url="https://github.com/dfinity/ICRC-1/tree/main/standards/ICRC-3";
        },
        {
          block_type = "2approve"; 
          url="https://github.com/dfinity/ICRC-1/tree/main/standards/ICRC-3";
        },
        {
          block_type = "1mint"; 
          url="https://github.com/dfinity/ICRC-1/tree/main/standards/ICRC-3";
        },
        {
          block_type = "1burn"; 
          url="https://github.com/dfinity/ICRC-1/tree/main/standards/ICRC-3";
        }
      ];
    };

    let default_icrc4_args : ICRC4.InitArgs = {
      max_balances = ?200;
      max_transfers = ?200;
      fee = ?#ICRC1;
    };

    let icrc1_args : ICRC1.InitArgs = switch(args){
      case(null) default_icrc1_args;
      case(?args){
        switch(args.icrc1){
          case(null) default_icrc1_args;
          case(?val){
            {
              val with minting_account = switch(
                val.minting_account){
                  case(?val) ?val;
                  case(null) {?{
                    owner = _owner;
                    subaccount = null;
                  }};
                };
            };
          };
        };
      };
    };

    let icrc2_args : ICRC2.InitArgs = switch(args){
      case(null) default_icrc2_args;
      case(?args){
        switch(args.icrc2){
          case(null) default_icrc2_args;
          case(?val) val;
        };
      };
    };


    let icrc3_args : ICRC3.InitArgs = switch(args){
      case(null) default_icrc3_args;
      case(?args){
        switch(args.icrc3){
          case(null) default_icrc3_args;
          case(?val) ?val;
        };
      };
    };

    let icrc4_args : ICRC4.InitArgs = switch(args){
      case(null) default_icrc4_args;
      case(?args){
        switch(args.icrc4){
          case(null) default_icrc4_args;
          case(?val) val;
        };
      };
    };

    stable let icrc1_migration_state = ICRC1.init(ICRC1.initialState(), #v0_1_0(#id),?icrc1_args, _owner);
    stable let icrc2_migration_state = ICRC2.init(ICRC2.initialState(), #v0_1_0(#id),?icrc2_args, _owner);
    stable let icrc4_migration_state = ICRC4.init(ICRC4.initialState(), #v0_1_0(#id),?icrc4_args, _owner);
    stable let icrc3_migration_state = ICRC3.init(ICRC3.initialState(), #v0_1_0(#id), icrc3_args, _owner);
    stable let cert_store : CertTree.Store = CertTree.newStore();
    let ct = CertTree.Ops(cert_store);


    stable var owner = _owner;

    let #v0_1_0(#data(icrc1_state_current)) = icrc1_migration_state;

    private var _icrc1 : ?ICRC1.ICRC1 = null;

    private func get_icrc1_state() : ICRC1.CurrentState {
      return icrc1_state_current;
    };

    private func get_icrc1_environment() : ICRC1.Environment {
    {
      get_time = null;
      get_fee = null;
      add_ledger_transaction = ?icrc3().add_record;
      can_transfer = null; //set to a function to intercept and add validation logic for transfers
    };
  };

    func icrc1() : ICRC1.ICRC1 {
    switch(_icrc1){
      case(null){
        let initclass : ICRC1.ICRC1 = ICRC1.ICRC1(?icrc1_migration_state, Principal.fromActor(this), get_icrc1_environment());
        ignore initclass.register_supported_standards({
          name = "ICRC-3";
          url = "https://github.com/dfinity/ICRC/ICRCs/icrc-3/"
        });
        ignore initclass.register_supported_standards({
          name = "ICRC-10";
          url = "https://github.com/dfinity/ICRC/ICRCs/icrc-10/"
        });
        _icrc1 := ?initclass;
        initclass;
      };
      case(?val) val;
    };
  };

  let #v0_1_0(#data(icrc2_state_current)) = icrc2_migration_state;

  private var _icrc2 : ?ICRC2.ICRC2 = null;

  private func get_icrc2_state() : ICRC2.CurrentState {
    return icrc2_state_current;
  };

  private func get_icrc2_environment() : ICRC2.Environment {
    {
      icrc1 = icrc1();
      get_fee = null;
      can_approve = null; //set to a function to intercept and add validation logic for approvals
      can_transfer_from = null; //set to a function to intercept and add validation logic for transfer froms
    };
  };

  func icrc2() : ICRC2.ICRC2 {
    switch(_icrc2){
      case(null){
        let initclass : ICRC2.ICRC2 = ICRC2.ICRC2(?icrc2_migration_state, Principal.fromActor(this), get_icrc2_environment());
        _icrc2 := ?initclass;
        initclass;
      };
      case(?val) val;
    };
  };

  let #v0_1_0(#data(icrc4_state_current)) = icrc4_migration_state;

  private var _icrc4 : ?ICRC4.ICRC4 = null;

  private func get_icrc4_state() : ICRC4.CurrentState {
    return icrc4_state_current;
  };

  private func get_icrc4_environment() : ICRC4.Environment {
    {
      icrc1 = icrc1();
      get_fee = null;
      can_approve = null; //set to a function to intercept and add validation logic for approvals
      can_transfer_from = null; //set to a function to intercept and add validation logic for transfer froms
    };
  };

  func icrc4() : ICRC4.ICRC4 {
    switch(_icrc4){
      case(null){
        let initclass : ICRC4.ICRC4 = ICRC4.ICRC4(?icrc4_migration_state, Principal.fromActor(this), get_icrc4_environment());
        _icrc4 := ?initclass;
        initclass;
      };
      case(?val) val;
    };
  };

  let #v0_1_0(#data(icrc3_state_current)) = icrc3_migration_state;

  private var _icrc3 : ?ICRC3.ICRC3 = null;

  private func get_icrc3_state() : ICRC3.CurrentState {
    return icrc3_state_current;
  };

  func get_state() : ICRC3.CurrentState{
    return icrc3_state_current;
  };

  private func get_icrc3_environment() : ICRC3.Environment {
    ?{
      updated_certification = ?updated_certification;
      get_certificate_store = ?get_certificate_store;
    };
  };

  func ensure_block_types(icrc3Class: ICRC3.ICRC3) : () {
    let supportedBlocks = Buffer.fromIter<ICRC3.BlockType>(icrc3Class.supported_block_types().vals());

    let blockequal = func(a : {block_type: Text}, b : {block_type: Text}) : Bool {
      a.block_type == b.block_type;
    };

    if(Buffer.indexOf<ICRC3.BlockType>({block_type = "1xfer"; url="";}, supportedBlocks, blockequal) == null){
      supportedBlocks.add({
            block_type = "1xfer"; 
            url="https://github.com/dfinity/ICRC-1/tree/main/standards/ICRC-3";
          });
    };

    if(Buffer.indexOf<ICRC3.BlockType>({block_type = "2xfer"; url="";}, supportedBlocks, blockequal) == null){
      supportedBlocks.add({
            block_type = "2xfer"; 
            url="https://github.com/dfinity/ICRC-1/tree/main/standards/ICRC-3";
          });
    };

    if(Buffer.indexOf<ICRC3.BlockType>({block_type = "2approve";url="";}, supportedBlocks, blockequal) == null){
      supportedBlocks.add({
            block_type = "2approve"; 
            url="https://github.com/dfinity/ICRC-1/tree/main/standards/ICRC-3";
          });
    };

    if(Buffer.indexOf<ICRC3.BlockType>({block_type = "1mint";url="";}, supportedBlocks, blockequal) == null){
      supportedBlocks.add({
            block_type = "1mint"; 
            url="https://github.com/dfinity/ICRC-1/tree/main/standards/ICRC-3";
          });
    };

    if(Buffer.indexOf<ICRC3.BlockType>({block_type = "1burn";url="";}, supportedBlocks, blockequal) == null){
      supportedBlocks.add({
            block_type = "1burn"; 
            url="https://github.com/dfinity/ICRC-1/tree/main/standards/ICRC-3";
          });
    };

    icrc3Class.update_supported_blocks(Buffer.toArray(supportedBlocks));
  };

  func icrc3() : ICRC3.ICRC3 {
    switch(_icrc3){
      case(null){
        let initclass : ICRC3.ICRC3 = ICRC3.ICRC3(?icrc3_migration_state, Principal.fromActor(this), get_icrc3_environment());
        _icrc3 := ?initclass;
        ensure_block_types(initclass);

        initclass;
      };
      case(?val) val;
    };
  };

  private func updated_certification(cert: Blob, lastIndex: Nat) : Bool{

    // D.print("updating the certification " # debug_show(CertifiedData.getCertificate(), ct.treeHash()));
    ct.setCertifiedData();
    // D.print("did the certification " # debug_show(CertifiedData.getCertificate()));
    return true;
  };

  private func get_certificate_store() : CertTree.Store {
    // D.print("returning cert store " # debug_show(cert_store));
    return cert_store;
  };

  /// Functions for the ICRC1 token standard
  public shared query func icrc1_name() : async Text {
      icrc1().name();
  };

  public shared query func icrc1_symbol() : async Text {
      icrc1().symbol();
  };

  public shared query func icrc1_decimals() : async Nat8 {
      icrc1().decimals();
  };

  public shared query func icrc1_fee() : async ICRC1.Balance {
      icrc1().fee();
  };

  public shared query func icrc1_metadata() : async [ICRC1.MetaDatum] {
      icrc1().metadata()
  };

  public shared query func icrc1_total_supply() : async ICRC1.Balance {
      icrc1().total_supply();
  };

  public shared query func icrc1_minting_account() : async ?ICRC1.Account {
      ?icrc1().minting_account();
  };

  public shared query func icrc1_balance_of(args : ICRC1.Account) : async ICRC1.Balance {
      icrc1().balance_of(args);
  };

  public shared query func icrc1_supported_standards() : async [ICRC1.SupportedStandard] {
      icrc1().supported_standards();
  };

  public shared query func icrc10_supported_standards() : async [ICRC1.SupportedStandard] {
      icrc1().supported_standards();
  };

  public shared ({ caller }) func icrc1_transfer(args : ICRC1.TransferArgs) : async ICRC1.TransferResult {
      switch(await* icrc1().transfer_tokens(caller, args, false, null)){
        case(#trappable(val)) val;
        case(#awaited(val)) val;
        case(#err(#trappable(err))) D.trap(err);
        case(#err(#awaited(err))) D.trap(err);
      };
  };

  public shared ({ caller }) func mint(args : ICRC1.Mint) : async ICRC1.TransferResult {
      if(caller != owner){ D.trap("Unauthorized")};

      switch( await* icrc1().mint_tokens(caller, args)){
        case(#trappable(val)) val;
        case(#awaited(val)) val;
        case(#err(#trappable(err))) D.trap(err);
        case(#err(#awaited(err))) D.trap(err);
      };
  };

  public shared ({ caller }) func burn(args : ICRC1.BurnArgs) : async ICRC1.TransferResult {
      switch( await*  icrc1().burn_tokens(caller, args, false)){
        case(#trappable(val)) val;
        case(#awaited(val)) val;
        case(#err(#trappable(err))) D.trap(err);
        case(#err(#awaited(err))) D.trap(err);
      };
  };

   public query ({ caller }) func icrc2_allowance(args: ICRC2.AllowanceArgs) : async ICRC2.Allowance {
      return icrc2().allowance(args.spender, args.account, false);
    };

  public shared ({ caller }) func icrc2_approve(args : ICRC2.ApproveArgs) : async ICRC2.ApproveResponse {
      switch(await*  icrc2().approve_transfers(caller, args, false, null)){
        case(#trappable(val)) val;
        case(#awaited(val)) val;
        case(#err(#trappable(err))) D.trap(err);
        case(#err(#awaited(err))) D.trap(err);
      };
  };

  public shared ({ caller }) func icrc2_transfer_from(args : ICRC2.TransferFromArgs) : async ICRC2.TransferFromResponse {
      switch(await* icrc2().transfer_tokens_from(caller, args, null)){
        case(#trappable(val)) val;
        case(#awaited(val)) val;
        case(#err(#trappable(err))) D.trap(err);
        case(#err(#awaited(err))) D.trap(err);
      };
  };

  public query func icrc3_get_blocks(args: ICRC3.GetBlocksArgs) : async ICRC3.GetBlocksResult{
    return icrc3().get_blocks(args);
  };

  public query func icrc3_get_archives(args: ICRC3.GetArchivesArgs) : async ICRC3.GetArchivesResult{
    return icrc3().get_archives(args);
  };

  public query func icrc3_get_tip_certificate() : async ?ICRC3.DataCertificate {
    return icrc3().get_tip_certificate();
  };

  public query func icrc3_supported_block_types() : async [ICRC3.BlockType] {
    return icrc3().supported_block_types();
  };

  public query func get_tip() : async ICRC3.Tip {
    return icrc3().get_tip();
  };

  public shared ({ caller }) func icrc4_transfer_batch(args: ICRC4.TransferBatchArgs) : async ICRC4.TransferBatchResults {
      switch(await* icrc4().transfer_batch_tokens(caller, args, null, null)){
        case(#trappable(val)) val;
        case(#awaited(val)) val;
        case(#err(#trappable(err))) err;
        case(#err(#awaited(err))) err;
      };
  };

  public shared query func icrc4_balance_of_batch(request : ICRC4.BalanceQueryArgs) : async ICRC4.BalanceQueryResult {
      icrc4().balance_of_batch(request);
  };

  public shared query func icrc4_maximum_update_batch_size() : async ?Nat {
      ?icrc4().get_state().ledger_info.max_transfers;
  };

  public shared query func icrc4_maximum_query_batch_size() : async ?Nat {
      ?icrc4().get_state().ledger_info.max_balances;
  };

  public shared ({ caller }) func admin_update_owner(new_owner : Principal) : async Bool {
    if(caller != owner){ D.trap("Unauthorized")};
    owner := new_owner;
    return true;
  };

  public shared ({ caller }) func admin_update_icrc1(requests : [ICRC1.UpdateLedgerInfoRequest]) : async [Bool] {
    if(caller != owner){ D.trap("Unauthorized")};
    return icrc1().update_ledger_info(requests);
  };

  public shared ({ caller }) func admin_update_icrc2(requests : [ICRC2.UpdateLedgerInfoRequest]) : async [Bool] {
    if(caller != owner){ D.trap("Unauthorized")};
    return icrc2().update_ledger_info(requests);
  };

  public shared ({ caller }) func admin_update_icrc4(requests : [ICRC4.UpdateLedgerInfoRequest]) : async [Bool] {
    if(caller != owner){ D.trap("Unauthorized")};
    return icrc4().update_ledger_info(requests);
  };

  /* /// Uncomment this code to establish have icrc1 notify you when a transaction has occured.
  private func transfer_listener(trx: ICRC1.Transaction, trxid: Nat) : () {

  };

  /// Uncomment this code to establish have icrc1 notify you when a transaction has occured.
  private func approval_listener(trx: ICRC2.TokenApprovalNotification, trxid: Nat) : () {

  };

  /// Uncomment this code to establish have icrc1 notify you when a transaction has occured.
  private func transfer_from_listener(trx: ICRC2.TransferFromNotification, trxid: Nat) : () {

  }; */

  private stable var _init = false;
  public shared(msg) func admin_init() : async () {
    //can only be called once


    if(_init == false){
      //ensure metadata has been registered
      let test1 = icrc1().metadata();
      let test2 = icrc2().metadata();
      let test4 = icrc4().metadata();
      let test3 = icrc3().stats();

      //uncomment the following line to register the transfer_listener
      //icrc1().register_token_transferred_listener<system>("my_namespace", transfer_listener);

      //uncomment the following line to register the transfer_listener
      //icrc2().register_token_approved_listener<system>("my_namespace", approval_listener);

      //uncomment the following line to register the transfer_listener
      //icrc2().register_transfer_from_listener<system>("my_namespace", transfer_from_listener);
    };
    _init := true;
  };


  // Deposit cycles into this canister.
  public shared func deposit_cycles() : async () {
      let amount = ExperimentalCycles.available();
      let accepted = ExperimentalCycles.accept<system>(amount);
      assert (accepted == amount);
  };

  system func postupgrade() {
    //re wire up the listener after upgrade
    //uncomment the following line to register the transfer_listener
      //icrc1().register_token_transferred_listener("my_namespace", transfer_listener);

      //uncomment the following line to register the transfer_listener
      //icrc2().register_token_approved_listener("my_namespace", approval_listener);

      //uncomment the following line to register the transfer_listener
      //icrc2().register_transfer_from_listener("my_namespace", transfer_from_listener);
  };

};
